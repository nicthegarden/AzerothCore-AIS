#!/bin/bash

# AzerothCore WoW Server Interactive Installation Script
# Based on build.txt guide
# Supports Docker deployment for testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/azerothcore-wotlk}"
REALM_NAME="${REALM_NAME:-My AzerothCore Realm}"
SERVER_IP="${SERVER_IP:-192.168.1.100}"
ACORE_USER="${ACORE_USER:-acore}"
ACORE_PASS="${ACORE_PASS:-acore}"

# Module choices (will be populated by user selections)
MODULES=()

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to ask yes/no question
ask_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response
    
    while true; do
        read -p "$prompt [Y/n]: " response
        response=${response:-$default}
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to display menu and get selection
show_menu() {
    local title="$1"
    shift
    local options=("$@")
    local choice
    
    echo ""
    echo "========================================"
    echo "$title"
    echo "========================================"
    
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[$i]}"
    done
    
    echo ""
    read -p "Enter your choice (1-${#options[@]}): " choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
        return $((choice-1))
    else
        print_error "Invalid choice. Please try again."
        return 255
    fi
}

# ============================================
# MAIN INSTALLATION MENU
# ============================================

show_main_menu() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║       AzerothCore WoW Server Installation Script          ║"
    echo "║              With Playerbots & Modules                    ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    local options=(
        "Full Installation (Native Linux - Recommended)"
        "Docker Installation (For Testing/Development)"
        "Update Existing Installation"
        "Install/Update Modules Only"
        "Configure Server Settings"
        "Start/Stop Server"
        "Exit"
    )
    
    show_menu "Select Installation Type" "${options[@]}"
    local choice=$?
    
    case $choice in
        0) install_native_linux ;;
        1) install_docker ;;
        2) update_installation ;;
        3) install_modules_menu ;;
        4) configure_server ;;
        5) server_control_menu ;;
        6) exit 0 ;;
        255) show_main_menu ;;
    esac
}

# ============================================
# NATIVE LINUX INSTALLATION
# ============================================

install_native_linux() {
    echo ""
    echo "========================================"
    echo "Native Linux Installation"
    echo "========================================"
    
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some operations require root privileges. You may be prompted for sudo password."
    fi
    
    # Step 1: System prerequisites
    print_status "Step 1: Installing system prerequisites..."
    apt update && apt upgrade -y
    apt install -y git curl unzip sudo tmux nano net-tools
    
    # Step 2: Clone repositories
    print_status "Step 2: Cloning AzerothCore repositories..."
    if [ -d "$INSTALL_DIR" ]; then
        if ask_yes_no "Directory $INSTALL_DIR already exists. Remove and reclone?"; then
            rm -rf "$INSTALL_DIR"
        else
            print_status "Using existing installation..."
        fi
    fi
    
    if [ ! -d "$INSTALL_DIR" ]; then
        git clone https://github.com/mod-playerbots/azerothcore-wotlk.git --branch=Playerbot "$INSTALL_DIR"
        cd "$INSTALL_DIR/modules"
        git clone https://github.com/mod-playerbots/mod-playerbots.git --branch=master
    fi
    
    # Step 3: Install dependencies
    print_status "Step 3: Installing AzerothCore dependencies..."
    cd "$INSTALL_DIR"
    
    # For Debian containers, set distro
    if [ -f /etc/debian_version ]; then
        if grep -q "debian" /etc/os-release; then
            sed -i 's/# OSDISTRO="ubuntu"/OSDISTRO="debian"/' conf/dist/config.sh 2>/dev/null || true
        fi
    fi
    
    ./acore.sh install-deps
    
    # Step 4: Select modules
    print_status "Step 4: Module Selection"
    install_modules_menu
    
    # Step 5: Select build options
    print_status "Step 5: Build Configuration"
    configure_build_options
    
    # Step 6: Compile
    print_status "Step 6: Compiling AzerothCore..."
    print_warning "This may take 15-45 minutes depending on your CPU..."
    
    read -p "Press Enter to start compilation or Ctrl+C to cancel..."
    
    if ask_yes_no "Perform full compile (clean build) or incremental build? (Y=Full/N=Incremental)"; then
        ./acore.sh compiler all
    else
        ./acore.sh compiler build
    fi
    
    # Step 7: Database setup
    print_status "Step 7: Setting up MySQL database..."
    setup_database
    
    # Step 8: Download client data
    print_status "Step 8: Downloading client data..."
    ./acore.sh client-data
    
    # Step 9: Copy configurations
    print_status "Step 9: Configuring server files..."
    setup_configurations
    
    # Step 10: Create start/stop scripts
    print_status "Step 10: Creating management scripts..."
    create_management_scripts
    
    # Step 11: Create first account
    print_status "Step 11: Initial setup complete!"
    
    print_success "Installation completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Start the server by running: start"
    echo "2. Connect to world session: wow"
    echo "3. Create your first account: account create <username> <password>"
    echo "4. Set GM level: account set gmlevel <username> 3 -1"
    echo ""
    
    ask_yes_no "Would you like to start the server now?" && start_server
}

# ============================================
# MODULE INSTALLATION MENU
# ============================================

install_modules_menu() {
    echo ""
    echo "========================================"
    echo "Available Modules"
    echo "========================================"
    echo ""
    echo "Select modules to install (space-separated numbers, e.g., '1 3 5'):"
    echo ""
    
    local modules_list=(
        "mod-no-hearthstone-cooldown - Remove hearthstone cooldown"
        "mod-account-mounts - Account-wide mounts"
        "mod-arac - All Races All Classes (Human Druids, etc.)"
        "mod-ah-bot-plus - Auction House Bot"
        "mod-transmog - Transmogrification"
        "mod-aoe-loot - Area of Effect looting"
        "mod-solo-lfg - Solo Looking For Group"
        "mod-autobalance - Auto balance dungeon difficulty"
        "mod-eluna - Lua scripting engine"
        "mod-cfbg - Cross Faction Battlegrounds"
    )
    
    for i in "${!modules_list[@]}"; do
        echo "$((i+1)). ${modules_list[$i]}"
    done
    echo ""
    echo "11. Done selecting"
    echo "12. Select all modules"
    echo "13. Skip modules (Playerbots already included)"
    echo ""
    
    read -p "Enter your choices: " choices
    
    # Process choices
    for choice in $choices; do
        case $choice in
            1) install_module "no-hearthstone-cooldown" "https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git" ;;
            2) install_module "account-mounts" "https://github.com/azerothcore/mod-account-mounts" ;;
            3) install_arac_module ;;
            4) install_ahbot_module ;;
            5) install_transmog_module ;;
            6) install_module "aoe-loot" "https://github.com/azerothcore/mod-aoe-loot" ;;
            7) install_module "solo-lfg" "https://github.com/azerothcore/mod-solo-lfg" ;;
            8) install_module "autobalance" "https://github.com/azerothcore/mod-autobalance" ;;
            9) install_module "eluna" "https://github.com/azerothcore/mod-eluna" ;;
            10) install_module "cfbg" "https://github.com/azerothcore/mod-cfbg" ;;
            11) break ;;
            12) 
                install_module "no-hearthstone-cooldown" "https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git"
                install_module "account-mounts" "https://github.com/azerothcore/mod-account-mounts"
                install_arac_module
                install_ahbot_module
                install_transmog_module
                install_module "aoe-loot" "https://github.com/azerothcore/mod-aoe-loot"
                install_module "solo-lfg" "https://github.com/azerothcore/mod-solo-lfg"
                break
                ;;
            13) print_status "Skipping additional modules. Only Playerbots will be installed." ;;
        esac
    done
}

install_module() {
    local module_name="$1"
    local module_url="$2"
    
    print_status "Installing module: $module_name"
    
    cd "$INSTALL_DIR/modules"
    
    if [ -d "mod-$module_name" ]; then
        print_warning "Module $module_name already exists, updating..."
        cd "mod-$module_name"
        git pull
    else
        git clone "$module_url"
    fi
    
    # Copy config if exists
    if [ -f "$INSTALL_DIR/env/dist/etc/modules/mod_${module_name}.conf.dist" ]; then
        cp "$INSTALL_DIR/env/dist/etc/modules/mod_${module_name}.conf.dist" \
           "$INSTALL_DIR/env/dist/etc/modules/mod_${module_name}.conf"
    fi
    
    MODULES+=("$module_name")
    print_success "Module $module_name installed"
}

install_arac_module() {
    print_status "Installing ARAC (All Races All Classes) module..."
    
    cd "$INSTALL_DIR/modules"
    
    if [ -d "mod-arac" ]; then
        cd "mod-arac"
        git pull
    else
        git clone https://github.com/heyitsbench/mod-arac.git
    fi
    
    print_warning "ARAC requires DBC patch files. These will be copied during configuration."
    print_warning "You will also need to download Patch-A.MPQ for your WoW client."
    
    MODULES+=("arac")
}

install_ahbot_module() {
    print_status "Installing Auction House Bot module..."
    
    cd "$INSTALL_DIR/modules"
    
    if [ -d "mod-ah-bot-plus" ]; then
        cd "mod-ah-bot-plus"
        git pull
    else
        git clone https://github.com/NathanHandley/mod-ah-bot-plus
    fi
    
    MODULES+=("ah-bot-plus")
}

install_transmog_module() {
    print_status "Installing Transmogrification module..."
    
    cd "$INSTALL_DIR/modules"
    
    if [ -d "mod-transmog" ]; then
        cd "mod-transmog"
        git pull
    else
        git clone https://github.com/azerothcore/mod-transmog.git
    fi
    
    # Copy SQL files
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-auth/acore_cms_subscriptions.sql" \
       "$INSTALL_DIR/data/sql/updates/db_auth/" 2>/dev/null || true
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-characters/trasmorg.sql" \
       "$INSTALL_DIR/data/sql/updates/db_characters/" 2>/dev/null || true
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-world/"*.sql \
       "$INSTALL_DIR/data/sql/updates/db_world/" 2>/dev/null || true
    
    MODULES+=("transmog")
}

# ============================================
# BUILD OPTIONS CONFIGURATION
# ============================================

configure_build_options() {
    echo ""
    echo "========================================"
    echo "Build Configuration Options"
    echo "========================================"
    
    # World server type
    local server_types=(
        "Normal (PvE)"
        "PvP"
        "RP (Roleplay)"
        "RP-PvP"
    )
    
    show_menu "Select Server Type" "${server_types[@]}"
    local server_type=$?
    
    case $server_type in
        0) SERVER_TYPE=0 ;;  # Normal
        1) SERVER_TYPE=1 ;;  # PvP
        2) SERVER_TYPE=6 ;;  # RP
        3) SERVER_TYPE=7 ;;  # RP-PvP
    esac
    
    # Bot configuration
    echo ""
    echo "Playerbot Configuration"
    echo "========================================"
    
    read -p "Minimum number of bots [400]: " MIN_BOTS
    MIN_BOTS=${MIN_BOTS:-400}
    
    read -p "Maximum number of bots [500]: " MAX_BOTS
    MAX_BOTS=${MAX_BOTS:-500}
    
    read -p "Enable bot auto-login at startup? [y/N]: " AUTOLOGIN
    AUTOLOGIN=${AUTOLOGIN:-n}
    
    # Cross-faction options
    echo ""
    echo "Cross-Faction Settings"
    echo "========================================"
    
    ask_yes_no "Allow cross-faction grouping?" && CROSS_GROUP=1 || CROSS_GROUP=0
    ask_yes_no "Allow cross-faction guilds?" && CROSS_GUILD=1 || CROSS_GUILD=0
    ask_yes_no "Allow cross-faction chat?" && CROSS_CHAT=1 || CROSS_CHAT=0
    ask_yes_no "Allow cross-faction auction house?" && CROSS_AUCTION=1 || CROSS_AUCTION=0
    
    # Other settings
    echo ""
    echo "Server Settings"
    echo "========================================"
    
    ask_yes_no "Enable instant logout? (disable 20-second wait)" && INSTANT_LOGOUT=1 || INSTANT_LOGOUT=0
    ask_yes_no "Enable quest tracking?" && QUEST_TRACKER=1 || QUEST_TRACKER=0
    
    print_status "Build configuration saved"
}

# ============================================
# DATABASE SETUP
# ============================================

setup_database() {
    # Configure MySQL
    print_status "Configuring MySQL..."
    
    # Update MySQL config
    cat >> /etc/mysql/mysql.conf.d/mysqld.cnf << EOF

# AzerothCore Configuration
bind-address            = 0.0.0.0
mysqlx-bind-address     = 0.0.0.0
disable_log_bin
EOF
    
    systemctl restart mysql
    
    # Create database user and databases
    mysql -u root << EOF
DROP USER IF EXISTS '$ACORE_USER'@'localhost';
CREATE USER '$ACORE_USER'@'localhost' IDENTIFIED BY '$ACORE_PASS' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
GRANT ALL PRIVILEGES ON * . * TO '$ACORE_USER'@'localhost' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`acore_world\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_characters\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_auth\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_playerbots\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON \`acore_world\` . * TO '$ACORE_USER'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_characters\` . * TO '$ACORE_USER'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_auth\` . * TO '$ACORE_USER'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_playerbots\` . * TO '$ACORE_USER'@'localhost' WITH GRANT OPTION;
EOF
    
    print_success "Database configured"
}

# ============================================
# CONFIGURATION SETUP
# ============================================

setup_configurations() {
    cd "$INSTALL_DIR"
    
    # Copy default configs
    cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf
    cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf
    cp env/dist/etc/modules/playerbots.conf.dist env/dist/etc/modules/playerbots.conf
    
    # Apply world server settings
    sed -i "s/GameType = 0/GameType = ${SERVER_TYPE:-1}/" env/dist/etc/worldserver.conf
    sed -i "s/AllowTwoSide.Interaction.Group = 0/AllowTwoSide.Interaction.Group = ${CROSS_GROUP:-1}/" env/dist/etc/worldserver.conf
    sed -i "s/AllowTwoSide.Interaction.Guild = 0/AllowTwoSide.Interaction.Guild = ${CROSS_GUILD:-0}/" env/dist/etc/worldserver.conf
    sed -i "s/AllowTwoSide.Interaction.Chat = 0/AllowTwoSide.Interaction.Chat = ${CROSS_CHAT:-0}/" env/dist/etc/worldserver.conf
    sed -i "s/AllowTwoSide.Interaction.Auction = 0/AllowTwoSide.Interaction.Auction = ${CROSS_AUCTION:-0}/" env/dist/etc/worldserver.conf
    
    if [ "${INSTANT_LOGOUT:-0}" -eq 1 ]; then
        sed -i "s/InstantLogout = 0/InstantLogout = 1/" env/dist/etc/worldserver.conf
    fi
    
    if [ "${QUEST_TRACKER:-0}" -eq 1 ]; then
        sed -i "s/Quests.EnableQuestTracker = 0/Quests.EnableQuestTracker = 1/" env/dist/etc/worldserver.conf
    fi
    
    # Apply playerbot settings
    sed -i "s/AiPlayerbot.MinRandomBots = .*/AiPlayerbot.MinRandomBots = ${MIN_BOTS:-400}/" env/dist/etc/modules/playerbots.conf
    sed -i "s/AiPlayerbot.MaxRandomBots = .*/AiPlayerbot.MaxRandomBots = ${MAX_BOTS:-500}/" env/dist/etc/modules/playerbots.conf
    
    if [ "${AUTOLOGIN:-n}" = "y" ]; then
        sed -i "s/AiPlayerbot.RandomBotLoginAtStartup = 0/AiPlayerbot.RandomBotLoginAtStartup = 1/" env/dist/etc/modules/playerbots.conf
    fi
    
    # ARAC module DBC copy if installed
    if [[ " ${MODULES[@]} " =~ " arac " ]]; then
        if [ -d "$INSTALL_DIR/modules/mod-arac/patch-contents/DBFilesContent" ]; then
            cp "$INSTALL_DIR/modules/mod-arac/patch-contents/DBFilesContent/"* "$INSTALL_DIR/env/dist/bin/dbc/"
        fi
        
        # Import ARAC SQL
        mysql -u root acore_world < "$INSTALL_DIR/modules/mod-arac/data/sql/db-world/arac.sql"
    fi
    
    print_success "Configurations applied"
}

# ============================================
# MANAGEMENT SCRIPTS
# ============================================

create_management_scripts() {
    # Create start script
    cat > /root/start.sh << 'EOF'
#!/bin/bash
cd ~/azerothcore-wotlk/env/dist/bin
authserver="./authserver"
worldserver="./worldserver"

authserver_session="auth-session"
worldserver_session="world-session"

if tmux new-session -d -s $authserver_session; then
    echo "Created authserver session: $authserver_session"
else
    echo "Error when trying to create authserver session: $authserver_session"
fi

if tmux new-session -d -s $worldserver_session; then
    echo "Created worldserver session: $worldserver_session"
else
    echo "Error when trying to create worldserver session: $worldserver_session"
fi

if tmux send-keys -t $authserver_session "$authserver" C-m; then
    echo "Executed \"$authserver\" inside $authserver_session"
    echo "You can attach to $authserver_session using \"tmux attach -t $authserver_session\""
else
    echo "Error when executing \"$authserver\" inside $authserver_session"
fi

if tmux send-keys -t $worldserver_session "$worldserver" C-m; then
    echo "Executed \"$worldserver\" inside $worldserver_session"
    echo "You can attach to $worldserver_session using \"tmux attach -t $worldserver_session\""
else
    echo "Error when executing \"$worldserver\" inside $worldserver_session"
fi
EOF
    
    chmod +x /root/start.sh
    
    # Add aliases to bashrc
    cat >> ~/.bashrc << EOF

# AzerothCore Aliases
alias wow='cd ~/azerothcore-wotlk; tmux attach -t world-session'
alias auth='cd ~/azerothcore-wotlk; tmux attach -t auth-session'
alias start='/root/start.sh'
alias stop='tmux kill-server'
alias compile='cd ~/azerothcore-wotlk; ./acore.sh compiler all'
alias build='cd ~/azerothcore-wotlk; ./acore.sh compiler build'
alias update='cd ~/azerothcore-wotlk; git pull; cd ~/azerothcore-wotlk/modules/mod-playerbots; git pull'
alias pb='nano ~/azerothcore-wotlk/env/dist/etc/modules/playerbots.conf'
alias world='nano ~/azerothcore-wotlk/env/dist/etc/worldserver.conf'
alias authconf='nano ~/azerothcore-wotlk/env/dist/etc/authserver.conf'
alias updatemods="cd ~/azerothcore-wotlk/modules; find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"
EOF
    
    source ~/.bashrc
    
    print_success "Management scripts created"
}

# ============================================
# DOCKER INSTALLATION
# ============================================

install_docker() {
    echo ""
    echo "========================================"
    echo "Docker Installation"
    echo "========================================"
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Create Docker directory
    mkdir -p "$INSTALL_DIR/docker"
    cd "$INSTALL_DIR/docker"
    
    # Create Dockerfile
    create_dockerfile
    
    # Create docker-compose.yml
    create_docker_compose
    
    # Create entrypoint script
    create_docker_entrypoint
    
    # Build and start
    print_status "Building Docker image..."
    docker-compose build
    
    print_success "Docker environment prepared!"
    echo ""
    echo "To start the server in Docker:"
    echo "  cd $INSTALL_DIR/docker && docker-compose up -d"
    echo ""
    echo "To view logs:"
    echo "  docker-compose logs -f"
    echo ""
    
    ask_yes_no "Start Docker containers now?" && docker-compose up -d
}

create_dockerfile() {
    cat > Dockerfile << 'EOF'
FROM debian:trixie-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    sudo \
    tmux \
    nano \
    net-tools \
    mysql-server \
    mysql-client \
    build-essential \
    cmake \
    clang \
    libssl-dev \
    libmysqlclient-dev \
    libace-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /azerothcore

# Copy entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose ports
EXPOSE 3724 8085 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
EOF
}

create_docker_compose() {
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  azerothcore:
    build: .
    container_name: azerothcore-server
    hostname: azerothcore
    restart: unless-stopped
    ports:
      - "3724:3724"      # Auth server
      - "8085:8085"      # World server
      - "3306:3306"      # MySQL (optional, for external access)
    volumes:
      - azerothcore-data:/azerothcore/env/dist
      - azerothcore-etc:/azerothcore/env/dist/etc
      - azerothcore-modules:/azerothcore/modules
    environment:
      - ACORE_USER=${ACORE_USER}
      - ACORE_PASS=${ACORE_PASS}
      - REALM_NAME=${REALM_NAME}
      - SERVER_IP=${SERVER_IP}
    networks:
      - azerothcore-network
    stdin_open: true
    tty: true

volumes:
  azerothcore-data:
  azerothcore-etc:
  azerothcore-modules:

networks:
  azerothcore-network:
    driver: bridge
EOF
}

create_docker_entrypoint() {
    cat > docker-entrypoint.sh << 'EOF'
#!/bin/bash
set -e

# Start MySQL
service mysql start

# Check if AzerothCore is already installed
if [ ! -d "/azerothcore/modules/mod-playerbots" ]; then
    echo "First run - Installing AzerothCore..."
    
    # Clone repositories
    cd /azerothcore
    git clone https://github.com/mod-playerbots/azerothcore-wotlk.git --branch=Playerbot .
    cd /azerothcore/modules
    git clone https://github.com/mod-playerbots/mod-playerbots.git --branch=master
    
    # Configure for Debian
    sed -i 's/# OSDISTRO="ubuntu"/OSDISTRO="debian"/' /azerothcore/conf/dist/config.sh
    
    # Install deps
    cd /azerothcore
    ./acore.sh install-deps
    
    # Compile
    ./acore.sh compiler all
    
    # Setup database
    mysql -u root << MYSQL_EOF
DROP USER IF EXISTS 'acore'@'localhost';
CREATE USER 'acore'@'localhost' IDENTIFIED BY 'acore' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
GRANT ALL PRIVILEGES ON * . * TO 'acore'@'localhost' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`acore_world\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_characters\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_auth\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`acore_playerbots\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON \`acore_world\` . * TO 'acore'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_characters\` . * TO 'acore'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_auth\` . * TO 'acore'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`acore_playerbots\` . * TO 'acore'@'localhost' WITH GRANT OPTION;
MYSQL_EOF
    
    # Download client data
    ./acore.sh client-data
    
    # Copy configs
    cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf
    cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf
    cp env/dist/etc/modules/playerbots.conf.dist env/dist/etc/modules/playerbots.conf
    
    # Set realm name
    mysql -u root acore_auth -e "UPDATE realmlist SET name = '${REALM_NAME:-AzerothCore Docker}' WHERE id = 1;"
fi

# Start servers based on command
case "$1" in
    start)
        echo "Starting AzerothCore servers..."
        cd /azerothcore/env/dist/bin
        
        # Start authserver
        ./authserver &
        AUTH_PID=$!
        
        # Start worldserver
        ./worldserver &
        WORLD_PID=$!
        
        echo "Authserver PID: $AUTH_PID"
        echo "Worldserver PID: $WORLD_PID"
        
        # Wait for processes
        wait $AUTH_PID $WORLD_PID
        ;;
    shell)
        echo "Starting shell..."
        /bin/bash
        ;;
    *)
        exec "$@"
        ;;
esac
EOF
    chmod +x docker-entrypoint.sh
}

# ============================================
# UPDATE FUNCTIONS
# ============================================

update_installation() {
    echo ""
    echo "========================================"
    echo "Update Installation"
    echo "========================================"
    
    if [ ! -d "$INSTALL_DIR" ]; then
        print_error "Installation not found at $INSTALL_DIR"
        exit 1
    fi
    
    cd "$INSTALL_DIR"
    
    print_status "Updating AzerothCore..."
    git pull
    
    print_status "Updating Playerbots module..."
    cd modules/mod-playerbots
    git pull
    cd ../..
    
    print_status "Updating all modules..."
    cd modules
    find . -mindepth 1 -maxdepth 1 -type d -exec git -C {} pull \;
    cd ..
    
    if ask_yes_no "Recompile after update?"; then
        ./acore.sh compiler build
    fi
    
    print_success "Update complete!"
}

# ============================================
# SERVER CONFIGURATION
# ============================================

configure_server() {
    echo ""
    echo "========================================"
    echo "Server Configuration"
    echo "========================================"
    
    local config_options=(
        "Change Realm Name"
        "Set Server IP (LAN)"
        "Set External IP (Internet)"
        "Configure Playerbots"
        "Configure World Server"
        "Configure Modules"
        "Back to Main Menu"
    )
    
    show_menu "Configuration Options" "${config_options[@]}"
    local choice=$?
    
    case $choice in
        0) 
            read -p "Enter new realm name: " new_name
            mysql -u root acore_auth -e "UPDATE realmlist SET name = '$new_name' WHERE id = 1;"
            print_success "Realm name updated to: $new_name"
            ;;
        1)
            read -p "Enter LAN IP address: " lan_ip
            mysql -u root acore_auth -e "UPDATE realmlist SET address = '$lan_ip' WHERE id = 1;"
            print_success "Server IP set to: $lan_ip"
            ;;
        2)
            read -p "Enter external IP or DDNS: " ext_ip
            mysql -u root acore_auth -e "UPDATE realmlist SET address = '$ext_ip' WHERE id = 1;"
            print_success "External IP set to: $ext_ip"
            print_warning "Remember to forward ports 3724 and 8085 on your router!"
            ;;
        3) nano "$INSTALL_DIR/env/dist/etc/modules/playerbots.conf" ;;
        4) nano "$INSTALL_DIR/env/dist/etc/worldserver.conf" ;;
        5) 
            echo "Available module configs:"
            ls -la "$INSTALL_DIR/env/dist/etc/modules/"
            read -p "Enter config filename to edit: " conf_file
            nano "$INSTALL_DIR/env/dist/etc/modules/$conf_file"
            ;;
        6) show_main_menu ;;
    esac
    
    ask_yes_no "Configure more options?" && configure_server || show_main_menu
}

# ============================================
# SERVER CONTROL
# ============================================

server_control_menu() {
    echo ""
    echo "========================================"
    echo "Server Control"
    echo "========================================"
    
    local options=(
        "Start Server"
        "Stop Server"
        "Restart Server"
        "Attach to World Server"
        "Attach to Auth Server"
        "Create Game Account"
        "Server Status"
        "Back to Main Menu"
    )
    
    show_menu "Server Control" "${options[@]}"
    local choice=$?
    
    case $choice in
        0) start_server ;;
        1) stop_server ;;
        2) restart_server ;;
        3) tmux attach -t world-session 2>/dev/null || print_error "World server not running" ;;
        4) tmux attach -t auth-session 2>/dev/null || print_error "Auth server not running" ;;
        5) create_account ;;
        6) check_server_status ;;
        7) show_main_menu ;;
    esac
    
    ask_yes_no "Return to server control menu?" && server_control_menu || show_main_menu
}

start_server() {
    if [ -f /root/start.sh ]; then
        /root/start.sh
    elif [ -d "$INSTALL_DIR" ]; then
        cd "$INSTALL_DIR/env/dist/bin"
        tmux new-session -d -s auth-session './authserver'
        tmux new-session -d -s world-session './worldserver'
        print_success "Server started!"
        print_status "Use 'wow' command to attach to world server"
    else
        print_error "Installation not found!"
    fi
}

stop_server() {
    tmux kill-server 2>/dev/null || true
    pkill -f authserver 2>/dev/null || true
    pkill -f worldserver 2>/dev/null || true
    print_success "Server stopped"
}

restart_server() {
    stop_server
    sleep 2
    start_server
}

create_account() {
    echo ""
    read -p "Enter username: " username
    read -p "Enter password: " password
    read -p "GM Level (0-3, 3=full GM): " gmlevel
    
    print_status "You need to be attached to the world server to create accounts."
    print_status "Please run: wow"
    print_status "Then type: account create $username $password"
    print_status "Then type: account set gmlevel $username $gmlevel -1"
}

check_server_status() {
    echo ""
    echo "Server Status:"
    echo "========================================"
    
    if pgrep -f authserver > /dev/null; then
        print_success "Auth Server: RUNNING"
    else
        print_error "Auth Server: STOPPED"
    fi
    
    if pgrep -f worldserver > /dev/null; then
        print_success "World Server: RUNNING"
    else
        print_error "World Server: STOPPED"
    fi
    
    if tmux has-session -t world-session 2>/dev/null; then
        print_success "World tmux session: ACTIVE"
    else
        print_error "World tmux session: NOT FOUND"
    fi
    
    if tmux has-session -t auth-session 2>/dev/null; then
        print_success "Auth tmux session: ACTIVE"
    else
        print_error "Auth tmux session: NOT FOUND"
    fi
}

# ============================================
# MAIN ENTRY POINT
# ============================================

main() {
    # Check if being sourced or executed
    if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
        return 0
    fi
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --install-dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            --realm-name)
                REALM_NAME="$2"
                shift 2
                ;;
            --server-ip)
                SERVER_IP="$2"
                shift 2
                ;;
            --docker)
                install_docker
                exit 0
                ;;
            --update)
                update_installation
                exit 0
                ;;
            --start)
                start_server
                exit 0
                ;;
            --stop)
                stop_server
                exit 0
                ;;
            --status)
                check_server_status
                exit 0
                ;;
            -h|--help)
                echo "AzerothCore Interactive Installation Script"
                echo ""
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --install-dir DIR    Set installation directory (default: ~/azerothcore-wotlk)"
                echo "  --realm-name NAME    Set realm name (default: 'My AzerothCore Realm')"
                echo "  --server-ip IP       Set server IP address (default: 192.168.1.100)"
                echo "  --docker             Run Docker installation"
                echo "  --update             Update existing installation"
                echo "  --start              Start the server"
                echo "  --stop               Stop the server"
                echo "  --status             Check server status"
                echo "  -h, --help           Show this help message"
                echo ""
                echo "Without options, runs interactive menu."
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Show interactive menu
    show_main_menu
}

# Run main function
main "$@"
