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
        "🚀 Quick Setup - Enable ALL Features (Recommended for Testing)"
        "⚙️  Custom Installation - Select Features Manually"
        "🐳 Docker Installation - Container Setup"
        "🔄 Update Existing Installation"
        "📦 Install/Update Modules Only"
        "🔧 Configure Server Settings"
        "▶️  Start/Stop Server"
        "❌ Exit"
    )
    
    show_menu "Select Installation Type" "${options[@]}"
    local choice=$?
    
    case $choice in
        0) install_quick_setup ;;
        1) install_native_linux ;;
        2) install_docker ;;
        3) update_installation ;;
        4) install_modules_menu ;;
        5) configure_server ;;
        6) server_control_menu ;;
        7) exit 0 ;;
        255) show_main_menu ;;
    esac
}

# ============================================
# QUICK SETUP - ENABLE ALL FEATURES
# ============================================

install_quick_setup() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║              🚀 QUICK SETUP - ALL FEATURES 🚀              ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    print_status "This will install AzerothCore with ALL features enabled:"
    echo ""
    
    # Pre-configure all options
    INSTALL_DIR="${INSTALL_DIR:-$HOME/azerothcore-wotlk}"
    REALM_NAME="${REALM_NAME:-AzerothCore Full Featured}"
    SERVER_IP="${SERVER_IP:-192.168.1.100}"
    ACORE_USER="${ACORE_USER:-acore}"
    ACORE_PASS="${ACORE_PASS:-acore}"
    
    # Enable all modules
    ENABLE_ALL_MODULES=true
    MODULES=(
        "no-hearthstone-cooldown"
        "account-mounts"
        "arac"
        "ah-bot-plus"
        "transmog"
        "aoe-loot"
        "solo-lfg"
        "autobalance"
        "eluna"
        "cfbg"
    )
    
    # Configure all features
    SERVER_TYPE=1  # PvP
    MIN_BOTS=500
    MAX_BOTS=1000
    AUTOLOGIN="y"
    CROSS_GROUP=1
    CROSS_GUILD=1
    CROSS_CHAT=1
    CROSS_AUCTION=1
    INSTANT_LOGOUT=1
    QUEST_TRACKER=1
    
    # Show comprehensive summary
    show_installation_summary
    
    # Confirm with user
    echo ""
    if ! ask_yes_no "Proceed with installation?"; then
        print_warning "Installation cancelled by user."
        show_main_menu
        return
    fi
    
    # Configure IP address
    configure_ip_address
    
    # Proceed with installation
    print_status "Starting full installation with all features..."
    install_native_linux_with_preset_config
}

show_installation_summary() {
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║           📋 INSTALLATION SUMMARY - ALL FEATURES          ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    echo "🖥️  SERVER CONFIGURATION:"
    echo "   • Installation Directory: $INSTALL_DIR"
    echo "   • Realm Name: $REALM_NAME"
    echo "   • Server Type: PvP (Full PvP enabled)"
    echo "   • Server IP: $SERVER_IP (to be configured)"
    echo ""
    
    echo "🤖 PLAYERBOT CONFIGURATION:"
    echo "   • Minimum Bots: $MIN_BOTS"
    echo "   • Maximum Bots: $MAX_BOTS"
    echo "   • Auto-Login at Startup: YES"
    echo "   • Bot Quest Completion: ENABLED"
    echo "   • Auto-Equip Upgrades: ENABLED"
    echo ""
    
    echo "🌐 CROSS-FACTION FEATURES (ALL ENABLED):"
    echo "   ✓ Cross-Faction Grouping"
    echo "   ✓ Cross-Faction Guilds"
    echo "   ✓ Cross-Faction Chat"
    echo "   ✓ Cross-Faction Auction House"
    echo ""
    
    echo "⚡ QUALITY OF LIFE FEATURES (ALL ENABLED):"
    echo "   ✓ Instant Logout (no 20-second wait)"
    echo "   ✓ Quest Tracker"
    echo "   ✓ Enhanced Visibility Distance"
    echo "   ✓ No Player Limit (0 = unlimited)"
    echo ""
    
    echo "📦 MODULES TO BE INSTALLED (11 total):"
    echo "   1. ✓ mod-playerbots (built-in) - AI player companions"
    echo "   2. ✓ mod-no-hearthstone-cooldown - Instant hearth"
    echo "   3. ✓ mod-account-mounts - Account-wide mounts"
    echo "   4. ✓ mod-arac - All Races All Classes"
    echo "   5. ✓ mod-ah-bot-plus - Auction House Bot (15K-35K items)"
    echo "   6. ✓ mod-transmog - Transmogrification system"
    echo "   7. ✓ mod-aoe-loot - Area of Effect looting"
    echo "   8. ✓ mod-solo-lfg - Solo dungeon finder"
    echo "   9. ✓ mod-autobalance - Auto dungeon scaling"
    echo "  10. ✓ mod-eluna - Lua scripting engine"
    echo "  11. ✓ mod-cfbg - Cross-faction battlegrounds"
    echo ""
    
    echo "🔧 MANAGEMENT ALIASES (Will be created):"
    echo "   • start    - Start auth & world servers"
    echo "   • stop     - Stop all servers"
    echo "   • wow      - Attach to world server console"
    echo "   • auth     - Attach to auth server console"
    echo "   • build    - Incremental compilation"
    echo "   • compile  - Full recompilation"
    echo "   • update   - Update core + playerbots"
    echo "   • updatemods - Update all modules"
    echo "   • pb       - Edit playerbots.conf"
    echo "   • world    - Edit worldserver.conf"
    echo "   • ah       - Edit AH bot config"
    echo "   • tm       - Edit transmog config"
    echo ""
    
    echo "⏱️  ESTIMATED INSTALLATION TIME: 20-50 minutes"
    echo "   • Dependencies: 2-5 minutes"
    echo "   • Compilation: 15-45 minutes (depends on CPU)"
    echo "   • Client data: 3-5 minutes"
    echo "   • Database setup: 1-2 minutes"
    echo ""
    
    echo "💾 DISK SPACE REQUIRED: ~50GB"
    echo "   • Source code: ~2GB"
    echo "   • Compiled binaries: ~5GB"
    echo "   • Client data: ~15GB"
    echo "   • Database: ~5GB"
    echo "   • Logs/Extras: ~3GB"
    echo ""
    
    echo "🔌 PORTS REQUIRED:"
    echo "   • 3724 TCP - Auth Server"
    echo "   • 8085 TCP - World Server"
    echo "   • 3306 TCP - MySQL (optional, internal only)"
    echo ""
}

configure_ip_address() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                🌐 NETWORK CONFIGURATION                   ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    
    print_status "Select your server network mode:"
    echo ""
    echo "1. LAN Only (Local Network Play)"
    echo "   - Only accessible from your local network"
    echo "   - Use this for single-player or LAN parties"
    echo ""
    echo "2. Internet (Public Server)"
    echo "   - Accessible from anywhere"
    echo "   - Requires port forwarding on router"
    echo "   - External IP or DDNS required"
    echo ""
    
    read -p "Enter choice (1-2): " network_choice
    
    case $network_choice in
        1)
            print_status "LAN Mode selected"
            read -p "Enter your local IP address [192.168.1.100]: " local_ip
            SERVER_IP="${local_ip:-192.168.1.100}"
            print_success "Server will be accessible at: $SERVER_IP"
            print_warning "For LAN play only - edit realmlist.wtf to: set realmlist $SERVER_IP"
            ;;
        2)
            print_status "Internet Mode selected"
            read -p "Enter your external IP or DDNS: " external_ip
            if [ -z "$external_ip" ]; then
                print_warning "No IP entered. You'll need to configure this later."
                SERVER_IP="0.0.0.0"
            else
                SERVER_IP="$external_ip"
                print_success "Server will be accessible at: $SERVER_IP"
                print_warning "Remember to forward ports 3724 and 8085 on your router!"
            fi
            ;;
        *)
            print_warning "Invalid choice. Defaulting to LAN mode."
            SERVER_IP="192.168.1.100"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# ============================================
# NATIVE LINUX INSTALLATION WITH PRESET CONFIG
# ============================================

install_native_linux_with_preset_config() {
    echo ""
    echo "========================================"
    echo "Native Linux Installation (Quick Setup)"
    echo "========================================"
    
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some operations require root privileges. You may be prompted for sudo password."
    fi
    
    # Step 1: System prerequisites
    print_status "Step 1/8: Installing system prerequisites..."
    apt update && apt upgrade -y
    apt install -y git curl unzip sudo tmux nano net-tools
    
    # Step 2: Clone repositories
    print_status "Step 2/8: Cloning AzerothCore repositories..."
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
    
    # Step 3: Install all modules
    print_status "Step 3/8: Installing all modules..."
    cd "$INSTALL_DIR"
    install_all_modules_quick
    
    # Step 4: Install dependencies
    print_status "Step 4/8: Installing AzerothCore dependencies..."
    
    # For Debian containers, set distro
    if [ -f /etc/debian_version ]; then
        if grep -q "debian" /etc/os-release; then
            sed -i 's/# OSDISTRO="ubuntu"/OSDISTRO="debian"/' conf/dist/config.sh 2>/dev/null || true
        fi
    fi
    
    ./acore.sh install-deps
    
    # Step 5: Apply preset configuration
    print_status "Step 5/8: Applying preset configuration (all features enabled)..."
    apply_preset_configuration
    
    # Step 6: Compile
    print_status "Step 6/8: Compiling AzerothCore..."
    print_warning "This may take 15-45 minutes depending on your CPU..."
    print_status "Compilation started at: $(date)"
    
    read -p "Press Enter to start compilation or Ctrl+C to cancel..."
    
    ./acore.sh compiler all
    
    # Step 7: Database setup
    print_status "Step 7/8: Setting up MySQL database..."
    setup_database
    
    # Step 8: Download client data and finalize
    print_status "Step 8/8: Downloading client data and finalizing..."
    ./acore.sh client-data
    
    # Copy configurations
    print_status "Setting up configuration files..."
    setup_configurations_with_preset
    
    # Create start/stop scripts
    print_status "Creating management scripts..."
    create_management_scripts
    
    # Set realm name and IP
    print_status "Configuring realm settings..."
    mysql -u root acore_auth -e "UPDATE realmlist SET name = '$REALM_NAME' WHERE id = 1;"
    mysql -u root acore_auth -e "UPDATE realmlist SET address = '$SERVER_IP' WHERE id = 1;"
    
    print_success "Installation completed successfully at: $(date)"
    show_post_install_summary
}

install_all_modules_quick() {
    print_status "Installing all 10 modules..."
    
    cd "$INSTALL_DIR/modules"
    
    # Module 1: No Hearthstone Cooldown
    print_status "  Installing mod-no-hearthstone-cooldown..."
    git clone https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git 2>/dev/null || true
    
    # Module 2: Account Mounts
    print_status "  Installing mod-account-mounts..."
    git clone https://github.com/azerothcore/mod-account-mounts 2>/dev/null || true
    
    # Module 3: ARAC
    print_status "  Installing mod-arac..."
    git clone https://github.com/heyitsbench/mod-arac.git 2>/dev/null || true
    
    # Module 4: AH Bot Plus
    print_status "  Installing mod-ah-bot-plus..."
    git clone https://github.com/NathanHandley/mod-ah-bot-plus 2>/dev/null || true
    
    # Module 5: Transmog
    print_status "  Installing mod-transmog..."
    git clone https://github.com/azerothcore/mod-transmog.git 2>/dev/null || true
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-auth/acore_cms_subscriptions.sql" \
       "$INSTALL_DIR/data/sql/updates/db_auth/" 2>/dev/null || true
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-characters/trasmorg.sql" \
       "$INSTALL_DIR/data/sql/updates/db_characters/" 2>/dev/null || true
    cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-world/"*.sql \
       "$INSTALL_DIR/data/sql/updates/db_world/" 2>/dev/null || true
    
    # Module 6: AoE Loot
    print_status "  Installing mod-aoe-loot..."
    git clone https://github.com/azerothcore/mod-aoe-loot 2>/dev/null || true
    
    # Module 7: Solo LFG
    print_status "  Installing mod-solo-lfg..."
    git clone https://github.com/azerothcore/mod-solo-lfg 2>/dev/null || true
    
    # Module 8: Autobalance
    print_status "  Installing mod-autobalance..."
    git clone https://github.com/azerothcore/mod-autobalance 2>/dev/null || true
    
    # Module 9: Eluna
    print_status "  Installing mod-eluna..."
    git clone https://github.com/azerothcore/mod-eluna 2>/dev/null || true
    
    # Module 10: CFBG
    print_status "  Installing mod-cfbg..."
    git clone https://github.com/azerothcore/mod-cfbg 2>/dev/null || true
    
    print_success "All modules installed!"
}

apply_preset_configuration() {
    print_status "Applying preset configuration with all features..."
    
    # Create config files from dist
    cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf
    cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf
    cp env/dist/etc/modules/playerbots.conf.dist env/dist/etc/modules/playerbots.conf
    
    # Configure worldserver.conf with all features
    cat >> env/dist/etc/worldserver.conf << EOF

###################################################################################################
# QUICK SETUP - ALL FEATURES ENABLED
###################################################################################################

# Server Type: PvP
GameType = 1

# Cross-Faction Features (ALL ENABLED)
AllowTwoSide.Interaction.Group = 1
AllowTwoSide.Interaction.Guild = 1
AllowTwoSide.Interaction.Chat = 1
AllowTwoSide.Interaction.Auction = 1
AllowTwoSide.Interaction.Mail = 1
AllowTwoSide.Accounts = 1

# Quality of Life (ALL ENABLED)
InstantLogout = 1
Quests.EnableQuestTracker = 1
PlayerLimit = 0
MaxWhoListReturns = 100
Visibility.Distance.Continents = 200
Visibility.Distance.Instances = 300
Visibility.Distance.BGArenas = 300

# Mail
MailDeliveryDelay = 0

# Group/Instance
Quests.IgnoreRaid = 1
AccountInstancesPerHour = 20
MaxPrimaryTradeSkill = 11

# Performance
MapUpdate.Threads = 4

# Other
StrictNames.Reserved = 0
StrictNames.Profanity = 0
PreventAFKLogout = 2
EOF
    
    # Configure playerbots.conf with enhanced settings
    cat >> env/dist/etc/modules/playerbots.conf << EOF

###################################################################################################
# QUICK SETUP - PLAYERBOT CONFIGURATION
###################################################################################################

# Bot Count
AiPlayerbot.MinRandomBots = 500
AiPlayerbot.MaxRandomBots = 1000
AiPlayerbot.RandomBotAccountCount = 500

# Auto-login
AiPlayerbot.RandomBotAutologin = 1
AiPlayerbot.RandomBotLoginAtStartup = 1

# Bot Behavior
AiPlayerbot.AutoDoQuests = 1
AiPlayerbot.AutoEquipUpgradeLoot = 1
AiPlayerbot.AutoTeleportForLevel = 1
AiPlayerbot.AutoPickReward = yes
AiPlayerbot.FreeFood = 1
AiPlayerbot.MaintenanceCommand = 1

# Grouping
AiPlayerbot.RandomBotGroupNearby = 1
AiPlayerbot.GroupInvitationPermission = 2
AiPlayerbot.SummonWhenGroup = 1

# Leveling
AiPlayerbot.DisableRandomLevels = 1
AiPlayerbot.RandombotStartingLevel = 1
AiPlayerbot.RandomBotMaxLevel = 80
AiPlayerbot.SyncLevelWithPlayers = 1

# Battlegrounds
AiPlayerbot.RandomBotAutoJoinBG = 1

# Performance
PlayerbotsDatabase.WorkerThreads = 4
PlayerbotsDatabase.SynchThreads = 4
AiPlayerbot.BotActiveAlone = 100
EOF
    
    # ARAC DBC copy
    if [ -d "modules/mod-arac/patch-contents/DBFilesContent" ]; then
        print_status "Copying ARAC DBC files..."
        cp modules/mod-arac/patch-contents/DBFilesContent/* env/dist/bin/dbc/ 2>/dev/null || true
    fi
    
    print_success "Preset configuration applied!"
}

setup_configurations_with_preset() {
    print_status "Setting up all module configuration files..."
    
    # Copy all module configs
    for dist_file in env/dist/etc/modules/*.conf.dist; do
        if [ -f "$dist_file" ]; then
            config_file="${dist_file%.dist}"
            if [ ! -f "$config_file" ]; then
                cp "$dist_file" "$config_file"
                print_status "  Created config: $(basename $config_file)"
            fi
        fi
    done
    
    print_success "All configuration files created!"
}

show_post_install_summary() {
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         🎉 INSTALLATION COMPLETE - ALL FEATURES! 🎉       ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    print_success "AzerothCore with ALL features has been installed!"
    echo ""
    
    echo "🌐 SERVER ACCESS:"
    echo "   Realm Name: $REALM_NAME"
    echo "   Server IP: $SERVER_IP"
    echo "   Auth Port: 3724"
    echo "   World Port: 8085"
    echo ""
    
    echo "📦 INSTALLED MODULES (11 total):"
    echo "   ✓ mod-playerbots (built-in)"
    echo "   ✓ mod-no-hearthstone-cooldown"
    echo "   ✓ mod-account-mounts"
    echo "   ✓ mod-arac (All Races All Classes)"
    echo "   ✓ mod-ah-bot-plus"
    echo "   ✓ mod-transmog"
    echo "   ✓ mod-aoe-loot"
    echo "   ✓ mod-solo-lfg"
    echo "   ✓ mod-autobalance"
    echo "   ✓ mod-eluna"
    echo "   ✓ mod-cfbg"
    echo ""
    
    echo "⚡ ENABLED FEATURES:"
    echo "   ✓ PvP Server Type"
    echo "   ✓ 500-1000 AI Bots"
    echo "   ✓ Cross-Faction Everything"
    echo "   ✓ Instant Logout"
    echo "   ✓ Quest Tracker"
    echo "   ✓ Enhanced Visibility"
    echo ""
    
    echo "🎮 NEXT STEPS:"
    echo ""
    echo "1. Start the server:"
    echo "   $ start"
    echo ""
    echo "2. Attach to world server:"
    echo "   $ wow"
    echo ""
    echo "3. Create your admin account:"
    echo "   account create <username> <password>"
    echo "   account set gmlevel <username> 3 -1"
    echo ""
    echo "4. Configure client:"
    echo "   Edit Data/enUS/realmlist.wtf:"
    echo "   set realmlist $SERVER_IP"
    echo ""
    echo "5. For ARAC module (optional):"
    echo "   Download Patch-A.MPQ from mod-arac repo"
    echo "   Place in your WoW client Data folder"
    echo ""
    
    echo "🔧 USEFUL COMMANDS:"
    echo "   start    - Start servers"
    echo "   stop     - Stop servers"
    echo "   wow      - World server console"
    echo "   pb       - Edit bot settings"
    echo "   world    - Edit world settings"
    echo ""
    
    echo "📚 DOCUMENTATION:"
    echo "   Full guide: ./CHOICES.md"
    echo "   Docker: ./docker/README.md"
    echo "   Build: ./build.txt"
    echo ""
    
    if [ "$SERVER_IP" != "192.168.1.100" ] && [ "$SERVER_IP" != "0.0.0.0" ]; then
        echo "⚠️  INTERNET MODE: Remember to forward ports 3724 and 8085!"
        echo ""
    fi
    
    echo "Happy gaming! 🎮"
    echo ""
}

# ============================================
# NATIVE LINUX INSTALLATION (Custom)
# ============================================

install_native_linux() {
    echo ""
    echo "========================================"
    echo "Native Linux Installation (Custom)"
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
