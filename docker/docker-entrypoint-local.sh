#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Function to setup MariaDB
setup_mysql() {
    print_status "Starting MariaDB..."
    service mariadb start
    sleep 2
    
    # Wait for MariaDB to be ready
    until mysqladmin ping -h localhost --silent; do
        print_status "Waiting for MariaDB to start..."
        sleep 1
    done
    
    print_status "Configuring MariaDB..."
    
    # Create databases and users
    mysql -u root << EOF
DROP DATABASE IF EXISTS \`acore_world\`;
DROP DATABASE IF EXISTS \`acore_characters\`;
DROP DATABASE IF EXISTS \`acore_auth\`;
DROP DATABASE IF EXISTS \`acore_playerbots\`;

CREATE DATABASE \`acore_world\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE \`acore_characters\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE \`acore_auth\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE \`acore_playerbots\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_unicode_ci;

DROP USER IF EXISTS '${ACORE_USER}'@'localhost';
DROP USER IF EXISTS '${ACORE_USER}'@'%';
CREATE USER '${ACORE_USER}'@'localhost' IDENTIFIED BY '${ACORE_PASS}';
CREATE USER '${ACORE_USER}'@'%' IDENTIFIED BY '${ACORE_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${ACORE_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO '${ACORE_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
    
    print_success "MariaDB configured"
}

# Function to check if AzerothCore is installed
check_installation() {
    if [ -d "/azerothcore/modules/mod-playerbots" ] && [ -f "/azerothcore/env/dist/bin/worldserver" ]; then
        return 0
    else
        return 1
    fi
}

# Function to install AzerothCore
install_azerothcore() {
    print_status "Installing AzerothCore..."
    
    # Change to install directory
    cd /azerothcore
    
    # Clone repositories
    print_status "Cloning AzerothCore repositories..."
    if [ ! -d ".git" ]; then
        git clone https://github.com/mod-playerbots/azerothcore-wotlk.git --branch=Playerbot --single-branch .
    fi
    
    # Clone playerbots module
    if [ ! -d "modules/mod-playerbots" ]; then
        cd modules
        git clone https://github.com/mod-playerbots/mod-playerbots.git --branch=master
        cd ..
    fi
    
    print_warning "Note: This is a DEMO container. Full compilation requires build tools."
    print_status "Installing essential dependencies..."
    apt-get update
    apt-get install -y build-essential cmake clang libssl-dev libmariadb-dev libace-dev \
        libcurl4-openssl-dev libbz2-dev libreadline-dev || true
    
    # Configure for Debian
    if [ -f "conf/dist/config.sh" ]; then
        sed -i 's/# OSDISTRO="ubuntu"/OSDISTRO="debian"/' conf/dist/config.sh
    fi
    
    # Install dependencies using acore script
    print_status "Running AzerothCore dependency installer..."
    ./acore.sh install-deps 2>&1 | tail -20 || true
    
    # Compile
    print_status "Compiling AzerothCore (this may take 15-45 minutes)..."
    print_status "Starting compilation at $(date)"
    ./acore.sh compiler all 2>&1 | tee /tmp/compile.log || {
        print_error "Compilation failed! Check /tmp/compile.log"
        return 1
    }
    
    # Download client data
    print_status "Downloading client data..."
    ./acore.sh client-data 2>&1 | tail -20 || true
    
    # Copy configs
    print_status "Setting up configuration files..."
    cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf 2>/dev/null || true
    cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf 2>/dev/null || true
    if [ -f "env/dist/etc/modules/playerbots.conf.dist" ]; then
        cp env/dist/etc/modules/playerbots.conf.dist env/dist/etc/modules/playerbots.conf
    fi
    
    # Set realm name
    mysql -u root acore_auth -e "UPDATE realmlist SET name = '${REALM_NAME}' WHERE id = 1;" 2>/dev/null || true
    
    print_success "AzerothCore installation complete!"
    print_status "Installation finished at $(date)"
}

# Function to demonstrate installation menu
demo_menu() {
    print_status "================================================"
    print_status "AzerothCore Installation Script - DEMO MODE"
    print_status "================================================"
    print_status ""
    print_status "This demonstrates the interactive menu system."
    print_status "In real usage, you would select options interactively."
    print_status ""
    print_status "Available Installation Modes:"
    print_status "  1. Full Installation (Native Linux - Recommended)"
    print_status "  2. Docker Installation (For Testing/Development)"
    print_status "  3. Update Existing Installation"
    print_status "  4. Install/Update Modules Only"
    print_status "  5. Configure Server Settings"
    print_status "  6. Start/Stop Server"
    print_status "  7. Exit"
    print_status ""
    print_status "Available Modules:"
    print_status "  • mod-no-hearthstone-cooldown"
    print_status "  • mod-account-mounts"
    print_status "  • mod-arac (All Races All Classes)"
    print_status "  • mod-ah-bot-plus (Auction House Bot)"
    print_status "  • mod-transmog (Transmogrification)"
    print_status "  • mod-aoe-loot"
    print_status "  • mod-solo-lfg"
    print_status "  • mod-autobalance"
    print_status "  • mod-eluna (Lua scripting)"
    print_status "  • mod-cfbg (Cross-Faction BGs)"
    print_status "  • mod-playerbots (built-in)"
    print_status ""
    print_status "Build Configuration Options:"
    print_status "  • Server Type: PvE, PvP, RP, RP-PvP"
    print_status "  • Bot Count: Min/Max (default 400-500)"
    print_status "  • Cross-Faction: Group, Guild, Chat, AH"
    print_status "  • QoL Features: Instant logout, Quest tracker"
    print_status ""
    print_status "Management Aliases (created after install):"
    print_status "  • start   - Start auth and world servers"
    print_status "  • stop    - Stop all servers"
    print_status "  • wow     - Attach to world server console"
    print_status "  • auth    - Attach to auth server console"
    print_status "  • build   - Incremental build"
    print_status "  • compile - Full recompile"
    print_status "  • update  - Update AzerothCore + Playerbots"
    print_status "  • updatemods - Update all modules"
    print_status "  • pb      - Edit playerbots config"
    print_status "  • world   - Edit worldserver config"
    print_status "  • ah      - Edit AH bot config"
    print_status ""
    print_status "================================================"
}

# Function to start servers
start_servers() {
    print_status "Starting AzerothCore servers..."
    
    if ! check_installation; then
        print_error "AzerothCore is not installed. Run 'install-azerothcore' first."
        return 1
    fi
    
    cd /azerothcore/env/dist/bin
    
    # Ensure logs directory exists
    mkdir -p /azerothcore/env/dist/logs
    
    # Start authserver
    print_status "Starting authserver..."
    ./authserver &
    AUTH_PID=$!
    
    # Start worldserver
    print_status "Starting worldserver..."
    ./worldserver &
    WORLD_PID=$!
    
    print_success "Servers started!"
    print_status "Authserver PID: $AUTH_PID"
    print_status "Worldserver PID: $WORLD_PID"
    print_status ""
    print_status "Useful commands:"
    print_status "  docker exec -it <container> tmux attach -t world-session"
    print_status "  docker exec -it <container> /azerothcore/env/dist/bin/worldserver"
    
    # Keep container running
    wait $AUTH_PID $WORLD_PID
}

# Function for shell mode
shell_mode() {
    print_status "Starting shell mode..."
    print_status "Available commands:"
    print_status "  install-azerothcore    - Run installation"
    print_status "  /docker-entrypoint.sh install  - Install AzerothCore"
    print_status "  /docker-entrypoint.sh start    - Start servers"
    print_status "  /docker-entrypoint.sh menu     - Show menu demo"
    print_status ""
    
    setup_mysql
    demo_menu
    
    if check_installation; then
        print_success "AzerothCore is already installed!"
        print_status "You can start it with: /docker-entrypoint.sh start"
    else
        print_warning "AzerothCore is not installed yet."
        print_status "To install, run: install-azerothcore"
    fi
    
    # Start a shell
    exec /bin/bash
}

# Main entrypoint logic
case "${1:-shell}" in
    install)
        setup_mysql
        install_azerothcore
        ;;
    start)
        setup_mysql
        start_servers
        ;;
    menu)
        demo_menu
        ;;
    shell|bash|interactive)
        shell_mode
        ;;
    *)
        print_error "Unknown command: $1"
        print_status "Usage: $0 [install|start|menu|shell]"
        exit 1
        ;;
esac
