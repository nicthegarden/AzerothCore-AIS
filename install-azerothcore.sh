#!/bin/bash

# AzerothCore WoW Server - Complete Installation Script for Debian 13
# Based on 2025-2026 AzerothCore + Playerbots Guide
# Version: 2.0 - Enhanced with all features and workarounds

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/azerothcore-wotlk}"
REALM_NAME="${REALM_NAME:-My AzerothCore Realm}"
SERVER_IP="${SERVER_IP:-192.168.1.100}"
ACORE_USER="${ACORE_USER:-acore}"
ACORE_PASS="${ACORE_PASS:-acore}"
EXTERNAL_IP=""
ADMIN_USERNAME=""
ADMIN_PASSWORD=""

# Feature flags
INSTALL_MODULES=()
SERVER_TYPE=""  # 0=PvE, 1=PvP, 6=RP, 7=RP-PvP
MIN_BOTS=400
MAX_BOTS=500
AUTOLOGIN=false
CROSS_GROUP=false
CROSS_GUILD=false
CROSS_CHAT=false
CROSS_AUCTION=false
INSTANT_LOGOUT=false
QUEST_TRACKER=false
ENABLE_FLYING_MOUNT=false

# Module flags
MOD_NO_HEARTHSTONE=false
MOD_ACCOUNT_MOUNTS=false
MOD_ARAC=false
MOD_AH_BOT=false
MOD_TRANSMOG=false
MOD_AOE_LOOT=false
MOD_SOLO_LFG=false
MOD_AUTOBALANCE=false
MOD_ELUNA=false
MOD_CFBG=false

# ============================================
# UTILITY FUNCTIONS
# ============================================

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

print_header() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

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

ask_input() {
    local prompt="$1"
    local default="$2"
    local response
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " response
        echo "${response:-$default}"
    else
        read -p "$prompt: " response
        echo "$response"
    fi
}

# ============================================
# MAIN MENU
# ============================================

show_main_menu() {
    print_header "AZEROTHCORE WOTLK SERVER - DEBIAN 13 INSTALLER"
    echo "A complete automated installation system for"
    echo "AzerothCore with Playerbots and all modules"
    echo ""
    echo "Based on: 2025-2026 Complete Installation Guide"
    echo "Debian Version: 13 (Trixie)"
    echo ""
    
    echo "═══════════════════════════════════════════════════════════"
    echo "  INSTALLATION OPTIONS"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "  1) 🚀 FULL INSTALL - All Features & Modules"
    echo "     → Installs everything with optimal settings"
    echo "     → 500-1000 bots, all modules, cross-faction"
    echo ""
    echo "  2) ⚙️  CUSTOM INSTALL - Choose Your Features"
    echo "     → Select specific modules and settings"
    echo "     → Configure bot counts and server type"
    echo ""
    echo "  3) 🧹 WIPE & REINSTALL - Clean Slate"
    echo "     → Removes existing installation"
    echo "     → Fresh start with full backup option"
    echo ""
    echo "  4) 📦 INSTALL MODULES ONLY"
    echo "     → Add modules to existing installation"
    echo "     → Recompile after installation"
    echo ""
    echo "  5) 🔄 UPDATE EXISTING"
    echo "     → Update AzerothCore and modules"
    echo "     → Option to recompile"
    echo ""
    echo "  6) 🎮 SERVER MANAGEMENT"
    echo "     → Start/Stop/Restart server"
    echo "     → Create accounts, check status"
    echo ""
    echo "  7) 🔧 CONFIGURATION"
    echo "     → Edit configs, change realm name"
    echo "     → Set IP addresses"
    echo ""
    echo "  8) 📖 DOCUMENTATION"
    echo "     → View installation guide"
    echo "     → View module information"
    echo ""
    echo "  9) ❌ EXIT"
    echo ""
    
    local choice=$(ask_input "Enter your choice" "1")
    
    case $choice in
        1) install_full ;;           # Full install with all features
        2) install_custom ;;         # Custom installation
        3) wipe_and_reinstall ;;     # Wipe and start fresh
        4) install_modules_only ;;   # Modules only
        5) update_existing ;;        # Update
        6) server_management ;;      # Management
        7) configuration ;;          # Config
        8) show_documentation ;;     # Docs
        9) exit 0 ;;
        *) 
            print_error "Invalid choice"
            show_main_menu
            ;;
    esac
}

# ============================================
# FULL INSTALLATION - ALL FEATURES
# ============================================

install_full() {
    print_header "🚀 FULL INSTALLATION - ALL FEATURES ENABLED"
    
    print_status "This will install AzerothCore with ALL features:"
    echo ""
    echo "✓ AzerothCore + Playerbots (500-1000 bots)"
    echo "✓ All 10 modules (ARAC, Transmog, AH Bot, etc.)"
    echo "✓ Cross-faction everything (groups, guilds, chat, AH)"
    echo "✓ Instant logout, quest tracker, enhanced visibility"
    echo "✓ Flying mount item (learnable at level 1)"
    echo "✓ PvP server type with all QoL features"
    echo ""
    
    if ! ask_yes_no "Proceed with full installation"; then
        show_main_menu
        return
    fi
    
    # Set all features
    INSTALL_DIR="$HOME/azerothcore-wotlk"
    SERVER_TYPE=1  # PvP
    MIN_BOTS=500
    MAX_BOTS=1000
    AUTOLOGIN=true
    CROSS_GROUP=true
    CROSS_GUILD=true
    CROSS_CHAT=true
    CROSS_AUCTION=true
    INSTANT_LOGOUT=true
    QUEST_TRACKER=true
    ENABLE_FLYING_MOUNT=true
    
    # Enable all modules
    MOD_NO_HEARTHSTONE=true
    MOD_ACCOUNT_MOUNTS=true
    MOD_ARAC=true
    MOD_AH_BOT=true
    MOD_TRANSMOG=true
    MOD_AOE_LOOT=true
    MOD_SOLO_LFG=true
    MOD_AUTOBALANCE=true
    MOD_ELUNA=true
    MOD_CFBG=true
    
    # Collect user information
    collect_user_info
    
    # Show summary and confirm
    show_installation_summary
    
    if ! ask_yes_no "Begin installation"; then
        show_main_menu
        return
    fi
    
    # Run installation steps
    run_installation_steps
}

# ============================================
# CUSTOM INSTALLATION
# ============================================

install_custom() {
    print_header "⚙️  CUSTOM INSTALLATION"
    
    # Step 1: Basic Information
    print_status "Step 1/7: Basic Configuration"
    INSTALL_DIR=$(ask_input "Installation directory" "$HOME/azerothcore-wotlk")
    REALM_NAME=$(ask_input "Realm name" "My AzerothCore Realm")
    
    # Step 2: Admin Account
    print_status "Step 2/7: Admin Account Setup"
    ADMIN_USERNAME=$(ask_input "Admin username")
    ADMIN_PASSWORD=$(ask_input "Admin password")
    
    # Step 3: Server Type
    print_status "Step 3/7: Server Type"
    echo "1) Normal (PvE)"
    echo "2) PvP"
    echo "3) RP (Roleplay)"
    echo "4) RP-PvP"
    local stype=$(ask_input "Select server type" "2")
    case $stype in
        1) SERVER_TYPE=0 ;;
        2) SERVER_TYPE=1 ;;
        3) SERVER_TYPE=6 ;;
        4) SERVER_TYPE=7 ;;
        *) SERVER_TYPE=1 ;;
    esac
    
    # Step 4: Network Configuration
    print_status "Step 4/7: Network Configuration"
    echo "1) LAN Only (Local network)"
    echo "2) Internet (Public access)"
    local net_type=$(ask_input "Network mode" "1")
    
    if [ "$net_type" = "2" ]; then
        SERVER_IP=$(ask_input "External IP or DDNS")
        print_warning "Remember to forward ports 3724 and 8085 on your router!"
    else
        SERVER_IP=$(ask_input "Local IP address" "192.168.1.100")
    fi
    
    # Step 5: Playerbot Configuration
    print_status "Step 5/7: Playerbot Configuration"
    MIN_BOTS=$(ask_input "Minimum number of bots" "400")
    MAX_BOTS=$(ask_input "Maximum number of bots" "500")
    
    if ask_yes_no "Enable bot auto-login at startup"; then
        AUTOLOGIN=true
    fi
    
    # Step 6: Features
    print_status "Step 6/7: Feature Selection"
    
    if ask_yes_no "Enable cross-faction grouping"; then
        CROSS_GROUP=true
    fi
    
    if ask_yes_no "Enable cross-faction guilds"; then
        CROSS_GUILD=true
    fi
    
    if ask_yes_no "Enable cross-faction chat"; then
        CROSS_CHAT=true
    fi
    
    if ask_yes_no "Enable cross-faction auction house"; then
        CROSS_AUCTION=true
    fi
    
    if ask_yes_no "Enable instant logout (skip 20s wait)"; then
        INSTANT_LOGOUT=true
    fi
    
    if ask_yes_no "Enable quest tracker"; then
        QUEST_TRACKER=true
    fi
    
    if ask_yes_no "Add flying mount item (learnable at level 1)"; then
        ENABLE_FLYING_MOUNT=true
    fi
    
    # Step 7: Module Selection
    print_status "Step 7/7: Module Selection"
    echo ""
    echo "Select modules to install:"
    echo ""
    
    ask_yes_no "1. No Hearthstone Cooldown" && MOD_NO_HEARTHSTONE=true
    ask_yes_no "2. Account-Wide Mounts" && MOD_ACCOUNT_MOUNTS=true
    ask_yes_no "3. All Races All Classes (ARAC)" && MOD_ARAC=true
    ask_yes_no "4. Auction House Bot" && MOD_AH_BOT=true
    ask_yes_no "5. Transmogrification" && MOD_TRANSMOG=true
    ask_yes_no "6. AoE Looting" && MOD_AOE_LOOT=true
    ask_yes_no "7. Solo LFG" && MOD_SOLO_LFG=true
    ask_yes_no "8. Auto Balance" && MOD_AUTOBALANCE=true
    ask_yes_no "9. Eluna Lua Engine" && MOD_ELUNA=true
    ask_yes_no "10. Cross-Faction BGs" && MOD_CFBG=true
    
    # Show summary
    show_installation_summary
    
    if ask_yes_no "Begin installation"; then
        run_installation_steps
    else
        show_main_menu
    fi
}

# ============================================
# WIPE AND REINSTALL
# ============================================

wipe_and_reinstall() {
    print_header "🧹 WIPE AND REINSTALL"
    
    print_warning "This will DELETE your existing installation!"
    print_warning "Directory to be removed: $INSTALL_DIR"
    echo ""
    
    if ! ask_yes_no "Are you sure you want to wipe everything"; then
        show_main_menu
        return
    fi
    
    # Backup option
    if ask_yes_no "Create backup before wiping"; then
        local backup_dir="$HOME/azerothcore-backup-$(date +%Y%m%d-%H%M%S)"
        print_status "Creating backup at $backup_dir..."
        
        if [ -d "$INSTALL_DIR" ]; then
            cp -r "$INSTALL_DIR" "$backup_dir"
            print_success "Backup created at $backup_dir"
        fi
        
        # Backup databases
        if command -v mysql &> /dev/null; then
            mkdir -p "$backup_dir/databases"
            mysqldump -u root acore_auth > "$backup_dir/databases/acore_auth.sql" 2>/dev/null || true
            mysqldump -u root acore_characters > "$backup_dir/databases/acore_characters.sql" 2>/dev/null || true
            mysqldump -u root acore_world > "$backup_dir/databases/acore_world.sql" 2>/dev/null || true
            mysqldump -u root acore_playerbots > "$backup_dir/databases/acore_playerbots.sql" 2>/dev/null || true
            print_success "Database backups created"
        fi
    fi
    
    # Stop servers
    print_status "Stopping any running servers..."
    tmux kill-server 2>/dev/null || true
    pkill -f authserver 2>/dev/null || true
    pkill -f worldserver 2>/dev/null || true
    
    # Remove installation
    if [ -d "$INSTALL_DIR" ]; then
        print_status "Removing $INSTALL_DIR..."
        rm -rf "$INSTALL_DIR"
    fi
    
    # Remove databases
    if ask_yes_no "Also remove databases (acore_*)"; then
        print_status "Dropping databases..."
        mysql -u root << 'EOF' 2>/dev/null || true
DROP DATABASE IF EXISTS acore_auth;
DROP DATABASE IF EXISTS acore_characters;
DROP DATABASE IF EXISTS acore_world;
DROP DATABASE IF EXISTS acore_playerbots;
EOF
        print_success "Databases removed"
    fi
    
    # Remove aliases
    print_status "Removing bash aliases..."
    sed -i '/# AzerothCore Aliases/,/^$/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias wow=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias auth=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias start=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias stop=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias compile=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias build=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias update=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias pb=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias world=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias updatemods=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias ah=/d' ~/.bashrc 2>/dev/null || true
    sed -i '/alias tm=/d' ~/.bashrc 2>/dev/null || true
    
    # Remove start script
    rm -f /root/start.sh
    
    print_success "System wiped clean!"
    echo ""
    
    if ask_yes_no "Proceed with fresh installation now"; then
        install_full
    else
        show_main_menu
    fi
}

# ============================================
# COLLECT USER INFORMATION
# ============================================

collect_user_info() {
    print_status "Collecting configuration information..."
    
    # Admin account
    ADMIN_USERNAME=$(ask_input "Admin username" "admin")
    ADMIN_PASSWORD=$(ask_input "Admin password")
    
    # MySQL credentials
    ACORE_USER=$(ask_input "MySQL username" "acore")
    ACORE_PASS=$(ask_input "MySQL password" "acore")
    
    # Network
    print_status "Network Configuration"
    echo "1) LAN Only (Local network play)"
    echo "2) Internet (Allow external connections)"
    local net_choice=$(ask_input "Select network mode" "1")
    
    if [ "$net_choice" = "2" ]; then
        print_status "Detecting external IP..."
        EXTERNAL_IP=$(curl -s ipv4.icanhazip.com 2>/dev/null || curl -s ifconfig.me 2>/dev/null || echo "")
        if [ -n "$EXTERNAL_IP" ]; then
            print_status "Detected external IP: $EXTERNAL_IP"
            SERVER_IP=$(ask_input "External IP or DDNS" "$EXTERNAL_IP")
        else
            SERVER_IP=$(ask_input "External IP or DDNS")
        fi
        print_warning "Remember to forward ports 3724 and 8085 on your router!"
    else
        # Detect local IP
        local detected_ip=$(ip route get 1 2>/dev/null | awk '{print $7; exit}' || echo "")
        if [ -z "$detected_ip" ]; then
            detected_ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "192.168.1.100")
        fi
        SERVER_IP=$(ask_input "Local IP address" "$detected_ip")
    fi
}

# ============================================
# SHOW INSTALLATION SUMMARY
# ============================================

show_installation_summary() {
    print_header "📋 INSTALLATION SUMMARY"
    
    echo -e "${CYAN}Server Configuration:${NC}"
    echo "  Installation Directory: $INSTALL_DIR"
    echo "  Realm Name: $REALM_NAME"
    echo "  Server IP: $SERVER_IP"
    case $SERVER_TYPE in
        0) echo "  Server Type: Normal (PvE)" ;;
        1) echo "  Server Type: PvP" ;;
        6) echo "  Server Type: RP" ;;
        7) echo "  Server Type: RP-PvP" ;;
    esac
    echo ""
    
    echo -e "${CYAN}Admin Account:${NC}"
    echo "  Username: $ADMIN_USERNAME"
    echo "  Password: [hidden]"
    echo ""
    
    echo -e "${CYAN}MySQL Credentials:${NC}"
    echo "  Username: $ACORE_USER"
    echo "  Password: [hidden]"
    echo ""
    
    echo -e "${CYAN}Playerbots:${NC}"
    echo "  Min Bots: $MIN_BOTS"
    echo "  Max Bots: $MAX_BOTS"
    echo "  Auto-Login: $AUTOLOGIN"
    echo ""
    
    echo -e "${CYAN}Cross-Faction Features:${NC}"
    echo "  Groups: $CROSS_GROUP"
    echo "  Guilds: $CROSS_GUILD"
    echo "  Chat: $CROSS_CHAT"
    echo "  Auction House: $CROSS_AUCTION"
    echo ""
    
    echo -e "${CYAN}Quality of Life:${NC}"
    echo "  Instant Logout: $INSTANT_LOGOUT"
    echo "  Quest Tracker: $QUEST_TRACKER"
    echo "  Flying Mount: $ENABLE_FLYING_MOUNT"
    echo ""
    
    echo -e "${CYAN}Modules to Install:${NC}"
    [ "$MOD_NO_HEARTHSTONE" = true ] && echo "  ✓ No Hearthstone Cooldown"
    [ "$MOD_ACCOUNT_MOUNTS" = true ] && echo "  ✓ Account-Wide Mounts"
    [ "$MOD_ARAC" = true ] && echo "  ✓ All Races All Classes (ARAC)"
    [ "$MOD_AH_BOT" = true ] && echo "  ✓ Auction House Bot"
    [ "$MOD_TRANSMOG" = true ] && echo "  ✓ Transmogrification"
    [ "$MOD_AOE_LOOT" = true ] && echo "  ✓ AoE Looting"
    [ "$MOD_SOLO_LFG" = true ] && echo "  ✓ Solo LFG"
    [ "$MOD_AUTOBALANCE" = true ] && echo "  ✓ Auto Balance"
    [ "$MOD_ELUNA" = true ] && echo "  ✓ Eluna Lua Engine"
    [ "$MOD_CFBG" = true ] && echo "  ✓ Cross-Faction BGs"
    echo ""
    
    echo -e "${CYAN}Estimated Time:${NC} 20-50 minutes"
    echo -e "${CYAN}Disk Space Required:${NC} ~50GB"
    echo ""
}

# ============================================
# RUN INSTALLATION STEPS
# ============================================

run_installation_steps() {
    local start_time=$(date +%s)
    
    print_header "🚀 BEGINNING INSTALLATION"
    
    # Step 1: System Preparation
    step_system_prep
    
    # Step 2: Clone Repositories
    step_clone_repos
    
    # Step 3: Install Dependencies
    step_install_deps
    
    # Step 4: Install Modules
    step_install_modules
    
    # Step 5: Configure Build
    step_configure_build
    
    # Step 6: Compile
    step_compile
    
    # Step 7: Configure MySQL
    step_configure_mysql
    
    # Step 8: Download Client Data
    step_download_data
    
    # Step 9: Setup Configurations
    step_setup_configs
    
    # Step 10: Create Scripts
    step_create_scripts
    
    # Step 11: Database Hotfix
    step_database_hotfix
    
    # Step 12: Optional Flying Mount
    step_add_flying_mount
    
    # Step 13: Create Admin Account
    step_create_admin
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    
    print_header "🎉 INSTALLATION COMPLETE!"
    print_success "Installation finished in $minutes minutes!"
    echo ""
    show_post_install_info
}

# ============================================
# INSTALLATION STEPS
# ============================================

step_system_prep() {
    print_header "STEP 1/13: SYSTEM PREPARATION"
    
    print_status "Updating package lists..."
    apt update
    
    print_status "Installing prerequisites..."
    apt install -y git curl unzip sudo tmux nano net-tools mariadb-server mariadb-client
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some operations may require sudo password"
    fi
    
    print_success "System preparation complete"
}

step_clone_repos() {
    print_header "STEP 2/13: CLONING REPOSITORIES"
    
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Directory $INSTALL_DIR already exists"
        if ask_yes_no "Remove and reclone"; then
            rm -rf "$INSTALL_DIR"
        else
            print_status "Using existing directory"
            return
        fi
    fi
    
    print_status "Cloning AzerothCore with Playerbots..."
    git clone https://github.com/mod-playerbots/azerothcore-wotlk.git --branch=Playerbot "$INSTALL_DIR"
    
    print_status "Cloning Playerbots module..."
    cd "$INSTALL_DIR/modules"
    git clone https://github.com/mod-playerbots/mod-playerbots.git --branch=master
    
    print_success "Repositories cloned"
}

step_install_deps() {
    print_header "STEP 3/13: INSTALLING DEPENDENCIES"
    
    cd "$INSTALL_DIR"
    
    # Fix for Debian 13 containers
    if [ -f /etc/debian_version ]; then
        print_status "Configuring for Debian..."
        if [ -f "conf/dist/config.sh" ]; then
            sed -i 's/# OSDISTRO="ubuntu"/OSDISTRO="debian"/' conf/dist/config.sh
        fi
    fi
    
    print_status "Running AzerothCore dependency installer..."
    ./acore.sh install-deps
    
    print_success "Dependencies installed"
}

step_install_modules() {
    print_header "STEP 4/13: INSTALLING MODULES"
    
    cd "$INSTALL_DIR/modules"
    
    # Module 1: No Hearthstone Cooldown
    if [ "$MOD_NO_HEARTHSTONE" = true ]; then
        print_status "Installing mod-no-hearthstone-cooldown..."
        git clone https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git 2>/dev/null || true
    fi
    
    # Module 2: Account Mounts
    if [ "$MOD_ACCOUNT_MOUNTS" = true ]; then
        print_status "Installing mod-account-mounts..."
        git clone https://github.com/azerothcore/mod-account-mounts 2>/dev/null || true
    fi
    
    # Module 3: ARAC
    if [ "$MOD_ARAC" = true ]; then
        print_status "Installing mod-arac..."
        git clone https://github.com/heyitsbench/mod-arac.git 2>/dev/null || true
        print_warning "ARAC requires Patch-A.MPQ in your WoW client Data folder"
    fi
    
    # Module 4: AH Bot Plus
    if [ "$MOD_AH_BOT" = true ]; then
        print_status "Installing mod-ah-bot-plus..."
        git clone https://github.com/NathanHandley/mod-ah-bot-plus 2>/dev/null || true
    fi
    
    # Module 5: Transmog
    if [ "$MOD_TRANSMOG" = true ]; then
        print_status "Installing mod-transmog..."
        git clone https://github.com/azerothcore/mod-transmog.git 2>/dev/null || true
        # Copy SQL files
        cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-auth/acore_cms_subscriptions.sql" \
           "$INSTALL_DIR/data/sql/updates/db_auth/" 2>/dev/null || true
        cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-characters/trasmorg.sql" \
           "$INSTALL_DIR/data/sql/updates/db_characters/" 2>/dev/null || true
        cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-world/"*.sql \
           "$INSTALL_DIR/data/sql/updates/db_world/" 2>/dev/null || true
    fi
    
    # Module 6: AoE Loot
    if [ "$MOD_AOE_LOOT" = true ]; then
        print_status "Installing mod-aoe-loot..."
        git clone https://github.com/azerothcore/mod-aoe-loot 2>/dev/null || true
    fi
    
    # Module 7: Solo LFG
    if [ "$MOD_SOLO_LFG" = true ]; then
        print_status "Installing mod-solo-lfg..."
        git clone https://github.com/azerothcore/mod-solo-lfg 2>/dev/null || true
    fi
    
    # Module 8: Auto Balance
    if [ "$MOD_AUTOBALANCE" = true ]; then
        print_status "Installing mod-autobalance..."
        git clone https://github.com/azerothcore/mod-autobalance 2>/dev/null || true
    fi
    
    # Module 9: Eluna
    if [ "$MOD_ELUNA" = true ]; then
        print_status "Installing mod-eluna..."
        git clone https://github.com/azerothcore/mod-eluna 2>/dev/null || true
    fi
    
    # Module 10: CFBG
    if [ "$MOD_CFBG" = true ]; then
        print_status "Installing mod-cfbg..."
        git clone https://github.com/azerothcore/mod-cfbg 2>/dev/null || true
    fi
    
    print_success "Modules installed"
}

step_configure_build() {
    print_header "STEP 5/13: CONFIGURING BUILD"
    
    cd "$INSTALL_DIR"
    
    # Copy default configs
    cp env/dist/etc/authserver.conf.dist env/dist/etc/authserver.conf
    cp env/dist/etc/worldserver.conf.dist env/dist/etc/worldserver.conf
    cp env/dist/etc/modules/playerbots.conf.dist env/dist/etc/modules/playerbots.conf
    
    # Configure worldserver.conf
    print_status "Configuring worldserver.conf..."
    
    # Server type
    echo "GameType = $SERVER_TYPE" >> env/dist/etc/worldserver.conf
    
    # Cross-faction
    [ "$CROSS_GROUP" = true ] && echo "AllowTwoSide.Interaction.Group = 1" >> env/dist/etc/worldserver.conf
    [ "$CROSS_GUILD" = true ] && echo "AllowTwoSide.Interaction.Guild = 1" >> env/dist/etc/worldserver.conf
    [ "$CROSS_CHAT" = true ] && echo "AllowTwoSide.Interaction.Chat = 1" >> env/dist/etc/worldserver.conf
    [ "$CROSS_AUCTION" = true ] && echo "AllowTwoSide.Interaction.Auction = 1" >> env/dist/etc/worldserver.conf
    
    # QoL features
    [ "$INSTANT_LOGOUT" = true ] && echo "InstantLogout = 1" >> env/dist/etc/worldserver.conf
    [ "$QUEST_TRACKER" = true ] && echo "Quests.EnableQuestTracker = 1" >> env/dist/etc/worldserver.conf
    
    # Additional settings
    cat >> env/dist/etc/worldserver.conf << 'EOF'

# Additional AzerothCore Settings
AllowTwoSide.Accounts = 1
PlayerLimit = 0
MaxWhoListReturns = 100
Visibility.Distance.Continents = 200
Visibility.Distance.Instances = 300
MapUpdate.Threads = 4
Quests.IgnoreRaid = 1
AccountInstancesPerHour = 20
MailDeliveryDelay = 0
MaxPrimaryTradeSkill = 11
StrictNames.Reserved = 0
StrictNames.Profanity = 0
PreventAFKLogout = 2
Warden.Enabled = 0
EOF
    
    # Configure playerbots.conf
    print_status "Configuring playerbots.conf..."
    
    cat >> env/dist/etc/modules/playerbots.conf << EOF

# Playerbot Configuration
AiPlayerbot.MinRandomBots = $MIN_BOTS
AiPlayerbot.MaxRandomBots = $MAX_BOTS
AiPlayerbot.RandomBotAutologin = $([ "$AUTOLOGIN" = true ] && echo "1" || echo "0")
AiPlayerbot.RandomBotLoginAtStartup = $([ "$AUTOLOGIN" = true ] && echo "1" || echo "0")
AiPlayerbot.AutoDoQuests = 1
AiPlayerbot.AutoEquipUpgradeLoot = 1
AiPlayerbot.AutoTeleportForLevel = 1
AiPlayerbot.AutoPickReward = yes
AiPlayerbot.FreeFood = 1
AiPlayerbot.MaintenanceCommand = 1
AiPlayerbot.RandomBotGroupNearby = 1
AiPlayerbot.GroupInvitationPermission = 2
AiPlayerbot.DisableRandomLevels = 1
AiPlayerbot.RandombotStartingLevel = 1
AiPlayerbot.RandomBotMaxLevel = 80
AiPlayerbot.SyncLevelWithPlayers = 1
AiPlayerbot.RandomBotAutoJoinBG = 1
PlayerbotsDatabase.WorkerThreads = 4
PlayerbotsDatabase.SynchThreads = 4
AiPlayerbot.BotActiveAlone = 100
EOF
    
    # Copy module configs
    print_status "Copying module configuration files..."
    for dist_file in env/dist/etc/modules/*.conf.dist; do
        if [ -f "$dist_file" ]; then
            config_file="${dist_file%.dist}"
            [ ! -f "$config_file" ] && cp "$dist_file" "$config_file"
        fi
    done
    
    print_success "Build configured"
}

step_compile() {
    print_header "STEP 6/13: COMPILING AZEROTHCORE"
    
    print_warning "This step takes 15-45 minutes depending on your CPU"
    print_status "Compilation started at: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    cd "$INSTALL_DIR"
    ./acore.sh compiler all
    
    print_success "Compilation complete at: $(date '+%Y-%m-%d %H:%M:%S')"
}

step_configure_mysql() {
    print_header "STEP 7/13: CONFIGURING MYSQL"
    
    # Configure MySQL for AzerothCore
    print_status "Updating MySQL configuration..."
    
    cat >> /etc/mysql/mariadb.conf.d/50-server.cnf << 'EOF'

# AzerothCore Configuration
bind-address            = 0.0.0.0
mysqlx-bind-address     = 0.0.0.0
disable_log_bin
EOF
    
    systemctl restart mariadb
    
    # Create databases and user
    print_status "Creating databases and user..."
    
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
    
    print_success "MySQL configured"
}

step_download_data() {
    print_header "STEP 8/13: DOWNLOADING CLIENT DATA"
    
    cd "$INSTALL_DIR"
    ./acore.sh client-data
    
    # Copy ARAC DBC files if installed
    if [ "$MOD_ARAC" = true ]; then
        if [ -d "$INSTALL_DIR/modules/mod-arac/patch-contents/DBFilesContent" ]; then
            print_status "Copying ARAC DBC files..."
            cp "$INSTALL_DIR/modules/mod-arac/patch-contents/DBFilesContent/"* "$INSTALL_DIR/env/dist/bin/dbc/" 2>/dev/null || true
        fi
    fi
    
    print_success "Client data downloaded"
}

step_setup_configs() {
    print_header "STEP 9/13: FINALIZING CONFIGURATION"
    
    # Set realm name and IP
    print_status "Setting realm configuration..."
    
    # Wait for databases to be ready
    sleep 2
    
    mysql -u root acore_auth -e "UPDATE realmlist SET name = '$REALM_NAME' WHERE id = 1;" 2>/dev/null || true
    mysql -u root acore_auth -e "UPDATE realmlist SET address = '$SERVER_IP' WHERE id = 1;" 2>/dev/null || true
    
    print_success "Configuration finalized"
}

step_create_scripts() {
    print_header "STEP 10/13: CREATING MANAGEMENT SCRIPTS"
    
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
    cat >> ~/.bashrc << 'EOF'

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
alias ah='nano ~/azerothcore-wotlk/env/dist/etc/modules/mod_ahbot.conf'
alias tm='nano ~/azerothcore-wotlk/env/dist/etc/modules/transmog.conf'
EOF
    
    # Source bashrc for current session
    source ~/.bashrc
    
    print_success "Management scripts created"
    print_status "Available commands: start, stop, wow, auth, build, compile, update, pb, world"
}

step_database_hotfix() {
    print_header "STEP 11/13: APPLYING DATABASE HOTFIX"
    
    print_status "Applying 2026-02-07 SQL hotfix workaround..."
    
    # Rename the problematic SQL file
    local sql_file="$INSTALL_DIR/modules/mod-playerbots/data/sql/characters/updates/2026_01_30_00_change_to_InnoDB.sql"
    
    if [ -f "$sql_file" ]; then
        mv "$sql_file" "${sql_file}.no"
        print_status "Temporarily disabled problematic SQL file"
    fi
    
    print_success "Database hotfix applied"
}

step_add_flying_mount() {
    if [ "$ENABLE_FLYING_MOUNT" = false ]; then
        return
    fi
    
    print_header "STEP 12/13: ADDING FLYING MOUNT ITEM"
    
    print_status "Creating Tome of World Flying item (Item ID: 701000)..."
    
    mysql -u root acore_world << 'EOF'
DELETE FROM `item_template` WHERE `entry`=701000;
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`) VALUES (701000, 9, 0, -1, 'Tome of World Flying', 61330, 7, 134217792, 0, 1, 4500000, 4500000, 0, -1, -1, 80, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 483, 0, -1, 0, -1, 0, -1, 31700, 6, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 'Learn to fly everywhere', 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 1);
EOF
    
    print_success "Flying mount item created!"
    print_status "Use in-game GM command: .additem 701000"
}

step_create_admin() {
    print_header "STEP 13/13: CREATING ADMIN ACCOUNT"
    
    print_status "Starting server for first time to initialize database..."
    
    # Start server in background
    cd "$INSTALL_DIR/env/dist/bin"
    
    # Start authserver
    tmux new-session -d -s auth-session './authserver'
    sleep 2
    
    # Start worldserver
    tmux new-session -d -s world-session './worldserver'
    
    print_status "Waiting for database initialization (this may take a few minutes)..."
    sleep 10
    
    # Wait for worldserver to be ready
    local attempts=0
    while [ $attempts -lt 60 ]; do
        if tmux capture-pane -t world-session -p 2>/dev/null | grep -q "AzerothCore rev."; then
            print_success "World server is ready!"
            break
        fi
        sleep 5
        attempts=$((attempts + 1))
        echo -n "."
    done
    
    echo ""
    
    # Create admin account
    print_status "Creating admin account: $ADMIN_USERNAME"
    tmux send-keys -t world-session "account create $ADMIN_USERNAME $ADMIN_PASSWORD" C-m
    sleep 2
    tmux send-keys -t world-session "account set gmlevel $ADMIN_USERNAME 3 -1" C-m
    sleep 2
    
    # Apply ARAC SQL if installed
    if [ "$MOD_ARAC" = true ]; then
        if [ -f "$INSTALL_DIR/modules/mod-arac/data/sql/db-world/arac.sql" ]; then
            print_status "Applying ARAC database changes..."
            mysql -u root acore_world < "$INSTALL_DIR/modules/mod-arac/data/sql/db-world/arac.sql"
        fi
    fi
    
    # Stop server
    print_status "Stopping server..."
    tmux kill-server 2>/dev/null || true
    sleep 2
    
    # Re-enable the SQL hotfix file
    local sql_file="$INSTALL_DIR/modules/mod-playerbots/data/sql/characters/updates/2026_01_30_00_change_to_InnoDB.sql"
    if [ -f "${sql_file}.no" ]; then
        mv "${sql_file}.no" "$sql_file"
        print_status "Re-enabling SQL hotfix file..."
        mysql -u root < "$sql_file" 2>/dev/null || true
    fi
    
    print_success "Admin account created!"
}

# ============================================
# POST-INSTALL INFORMATION
# ============================================

show_post_install_info() {
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  🎉 AZEROTHCORE SERVER INSTALLATION COMPLETE! 🎉"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    
    echo -e "${CYAN}🌐 SERVER ACCESS:${NC}"
    echo "  Realm Name: $REALM_NAME"
    echo "  Server IP: $SERVER_IP"
    echo "  Auth Port: 3724"
    echo "  World Port: 8085"
    echo ""
    
    echo -e "${CYAN}👤 ADMIN ACCOUNT:${NC}"
    echo "  Username: $ADMIN_USERNAME"
    echo "  Password: [hidden]"
    echo "  GM Level: 3 (Full Administrator)"
    echo ""
    
    echo -e "${CYAN}🎮 NEXT STEPS:${NC}"
    echo ""
    echo "1. Start the server:"
    echo "   $ start"
    echo ""
    echo "2. Connect to world server console:"
    echo "   $ wow"
    echo "   (Press CTRL+B, then D to detach)"
    echo ""
    echo "3. Configure your WoW client:"
    echo "   Edit Data/enUS/realmlist.wtf:"
    echo "   set realmlist $SERVER_IP"
    echo ""
    echo "4. Login with your admin account"
    echo ""
    
    echo -e "${CYAN}🔧 USEFUL COMMANDS:${NC}"
    echo "  start      - Start auth & world servers"
    echo "  stop       - Stop all servers"
    echo "  wow        - Attach to world server console"
    echo "  auth       - Attach to auth server console"
    echo "  build      - Incremental compilation"
    echo "  compile    - Full recompilation"
    echo "  update     - Update AzerothCore + Playerbots"
    echo "  updatemods - Update all modules"
    echo "  pb         - Edit playerbots.conf"
    echo "  world      - Edit worldserver.conf"
    echo ""
    
    if [ "$ENABLE_FLYING_MOUNT" = true ]; then
        echo -e "${CYAN}🐉 FLYING MOUNT:${NC}"
        echo "  Item ID: 701000 (Tome of World Flying)"
        echo "  In-game GM command: .additem 701000"
        echo ""
    fi
    
    if [ "$MOD_ARAC" = true ]; then
        echo -e "${CYAN}⚠️  ARAC MODULE:${NC}"
        echo "  Download Patch-A.MPQ from:"
        echo "  https://github.com/heyitsbench/mod-arac"
        echo "  Place it in your WoW client Data folder"
        echo ""
    fi
    
    if [ "$MOD_AH_BOT" = true ]; then
        echo -e "${CYAN}🏛️  AUCTION HOUSE BOT:${NC}"
        echo "  Setup required:"
        echo "  1. Start server: start"
        echo "  2. Attach: wow"
        echo "  3. Create account: account create ahbot password"
        echo "  4. Login in-game and create character"
        echo "  5. Get GUID: lookup player account ahbot"
        echo "  6. Edit config: ah"
        echo "  7. Set AuctionHouseBot.GUIDs = [your GUID]"
        echo ""
    fi
    
    if [ "$MOD_TRANSMOG" = true ]; then
        echo -e "${CYAN}✨ TRANSMOG MODULE:${NC}"
        echo "  In-game GM command: .npc add 190010"
        echo "  Edit config: tm"
        echo ""
    fi
    
    if [ -n "$EXTERNAL_IP" ]; then
        echo -e "${CYAN}🌐 INTERNET ACCESS:${NC}"
        echo "  External IP: $EXTERNAL_IP"
        echo "  Remember to forward ports 3724 and 8085!"
        echo ""
    fi
    
    echo "═══════════════════════════════════════════════════════════"
    echo "  📖 Documentation: $SCRIPT_DIR/CHOICES.md"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    
    read -p "Press Enter to return to main menu..."
    show_main_menu
}

# ============================================
# MODULES ONLY INSTALLATION
# ============================================

install_modules_only() {
    print_header "📦 INSTALL MODULES ONLY"
    
    if [ ! -d "$INSTALL_DIR" ]; then
        print_error "AzerothCore not found at $INSTALL_DIR"
        print_status "Please run full installation first"
        read -p "Press Enter to continue..."
        show_main_menu
        return
    fi
    
    print_status "Available modules:"
    echo "1) No Hearthstone Cooldown"
    echo "2) Account-Wide Mounts"
    echo "3) All Races All Classes (ARAC)"
    echo "4) Auction House Bot"
    echo "5) Transmogrification"
    echo "6) AoE Looting"
    echo "7) Solo LFG"
    echo "8) Auto Balance"
    echo "9) Eluna Lua Engine"
    echo "10) Cross-Faction BGs"
    echo "11) Install ALL modules"
    echo ""
    
    read -p "Enter module numbers (space-separated): " choices
    
    cd "$INSTALL_DIR/modules"
    
    for choice in $choices; do
        case $choice in
            1) 
                git clone https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git 2>/dev/null || true
                print_success "No Hearthstone Cooldown installed"
                ;;
            2)
                git clone https://github.com/azerothcore/mod-account-mounts 2>/dev/null || true
                print_success "Account Mounts installed"
                ;;
            3)
                git clone https://github.com/heyitsbench/mod-arac.git 2>/dev/null || true
                print_success "ARAC installed (remember Patch-A.MPQ!)"
                ;;
            4)
                git clone https://github.com/NathanHandley/mod-ah-bot-plus 2>/dev/null || true
                print_success "AH Bot installed"
                ;;
            5)
                git clone https://github.com/azerothcore/mod-transmog.git 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-auth/acore_cms_subscriptions.sql" \
                   "$INSTALL_DIR/data/sql/updates/db_auth/" 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-characters/trasmorg.sql" \
                   "$INSTALL_DIR/data/sql/updates/db_characters/" 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-world/"*.sql \
                   "$INSTALL_DIR/data/sql/updates/db_world/" 2>/dev/null || true
                print_success "Transmog installed"
                ;;
            6)
                git clone https://github.com/azerothcore/mod-aoe-loot 2>/dev/null || true
                print_success "AoE Loot installed"
                ;;
            7)
                git clone https://github.com/azerothcore/mod-solo-lfg 2>/dev/null || true
                print_success "Solo LFG installed"
                ;;
            8)
                git clone https://github.com/azerothcore/mod-autobalance 2>/dev/null || true
                print_success "Auto Balance installed"
                ;;
            9)
                git clone https://github.com/azerothcore/mod-eluna 2>/dev/null || true
                print_success "Eluna installed"
                ;;
            10)
                git clone https://github.com/azerothcore/mod-cfbg 2>/dev/null || true
                print_success "CFBG installed"
                ;;
            11)
                git clone https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-account-mounts 2>/dev/null || true
                git clone https://github.com/heyitsbench/mod-arac.git 2>/dev/null || true
                git clone https://github.com/NathanHandley/mod-ah-bot-plus 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-transmog.git 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-auth/acore_cms_subscriptions.sql" \
                   "$INSTALL_DIR/data/sql/updates/db_auth/" 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-characters/trasmorg.sql" \
                   "$INSTALL_DIR/data/sql/updates/db_characters/" 2>/dev/null || true
                cp "$INSTALL_DIR/modules/mod-transmog/data/sql/db-world/"*.sql \
                   "$INSTALL_DIR/data/sql/updates/db_world/" 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-aoe-loot 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-solo-lfg 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-autobalance 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-eluna 2>/dev/null || true
                git clone https://github.com/azerothcore/mod-cfbg 2>/dev/null || true
                print_success "All modules installed"
                ;;
        esac
    done
    
    if ask_yes_no "Recompile now"; then
        cd "$INSTALL_DIR"
        ./acore.sh compiler build
        print_success "Compilation complete!"
    fi
    
    read -p "Press Enter to continue..."
    show_main_menu
}

# ============================================
# UPDATE EXISTING
# ============================================

update_existing() {
    print_header "🔄 UPDATE EXISTING INSTALLATION"
    
    if [ ! -d "$INSTALL_DIR" ]; then
        print_error "Installation not found at $INSTALL_DIR"
        read -p "Press Enter to continue..."
        show_main_menu
        return
    fi
    
    print_status "Updating AzerothCore..."
    cd "$INSTALL_DIR"
    git pull
    
    print_status "Updating Playerbots module..."
    cd modules/mod-playerbots
    git pull
    cd ../..
    
    print_status "Updating all modules..."
    cd modules
    find . -mindepth 1 -maxdepth 1 -type d -exec git -C {} pull \;
    cd ..
    
    if ask_yes_no "Recompile after update"; then
        ./acore.sh compiler build
        print_success "Update and compilation complete!"
    else
        print_success "Update complete (source only)"
    fi
    
    read -p "Press Enter to continue..."
    show_main_menu
}

# ============================================
# SERVER MANAGEMENT
# ============================================

server_management() {
    print_header "🎮 SERVER MANAGEMENT"
    
    echo "1) Start Server"
    echo "2) Stop Server"
    echo "3) Restart Server"
    echo "4) Attach to World Server"
    echo "5) Attach to Auth Server"
    echo "6) Check Status"
    echo "7) Create Game Account"
    echo "8) Back to Main Menu"
    echo ""
    
    local choice=$(ask_input "Select option" "1")
    
    case $choice in
        1)
            if [ -f /root/start.sh ]; then
                /root/start.sh
            else
                print_error "Start script not found. Installation may be incomplete."
            fi
            ;;
        2)
            tmux kill-server 2>/dev/null || true
            pkill -f authserver 2>/dev/null || true
            pkill -f worldserver 2>/dev/null || true
            print_success "Server stopped"
            ;;
        3)
            tmux kill-server 2>/dev/null || true
            pkill -f authserver 2>/dev/null || true
            pkill -f worldserver 2>/dev/null || true
            sleep 2
            /root/start.sh 2>/dev/null || print_error "Start script not found"
            ;;
        4)
            tmux attach -t world-session 2>/dev/null || print_error "World server not running"
            ;;
        5)
            tmux attach -t auth-session 2>/dev/null || print_error "Auth server not running"
            ;;
        6)
            echo ""
            echo "Server Status:"
            echo "─────────────"
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
            ;;
        7)
            echo ""
            local acc_user=$(ask_input "Account username")
            local acc_pass=$(ask_input "Account password")
            print_status "To create account, run: wow"
            print_status "Then type: account create $acc_user $acc_pass"
            ;;
        8)
            show_main_menu
            return
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    server_management
}

# ============================================
# CONFIGURATION
# ============================================

configuration() {
    print_header "🔧 CONFIGURATION"
    
    echo "1) Change Realm Name"
    echo "2) Set Server IP (LAN)"
    echo "3) Set External IP/DDNS"
    echo "4) Edit Playerbots Config"
    echo "5) Edit Worldserver Config"
    echo "6) Edit Module Configs"
    echo "7) Back to Main Menu"
    echo ""
    
    local choice=$(ask_input "Select option" "1")
    
    case $choice in
        1)
            local new_name=$(ask_input "New realm name")
            mysql -u root acore_auth -e "UPDATE realmlist SET name = '$new_name' WHERE id = 1;" 2>/dev/null
            print_success "Realm name updated to: $new_name"
            ;;
        2)
            local new_ip=$(ask_input "Local IP address")
            mysql -u root acore_auth -e "UPDATE realmlist SET address = '$new_ip' WHERE id = 1;" 2>/dev/null
            print_success "Server IP set to: $new_ip"
            ;;
        3)
            local ext_ip=$(ask_input "External IP or DDNS")
            mysql -u root acore_auth -e "UPDATE realmlist SET address = '$ext_ip' WHERE id = 1;" 2>/dev/null
            print_success "External IP set to: $ext_ip"
            print_warning "Remember to forward ports 3724 and 8085!"
            ;;
        4)
            nano "$INSTALL_DIR/env/dist/etc/modules/playerbots.conf" 2>/dev/null || print_error "File not found"
            ;;
        5)
            nano "$INSTALL_DIR/env/dist/etc/worldserver.conf" 2>/dev/null || print_error "File not found"
            ;;
        6)
            echo "Available configs:"
            ls "$INSTALL_DIR/env/dist/etc/modules/" 2>/dev/null || print_error "Directory not found"
            local conf_file=$(ask_input "Config filename to edit")
            nano "$INSTALL_DIR/env/dist/etc/modules/$conf_file" 2>/dev/null || print_error "File not found"
            ;;
        7)
            show_main_menu
            return
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    configuration
}

# ============================================
# DOCUMENTATION
# ============================================

show_documentation() {
    print_header "📖 DOCUMENTATION"
    
    echo "1) View Installation Guide (CHOICES.md)"
    echo "2) View Module Information"
    echo "3) View GM Commands"
    echo "4) View Troubleshooting"
    echo "5) Back to Main Menu"
    echo ""
    
    local choice=$(ask_input "Select option" "1")
    
    case $choice in
        1)
            if [ -f "$SCRIPT_DIR/CHOICES.md" ]; then
                less "$SCRIPT_DIR/CHOICES.md"
            else
                print_error "Documentation not found"
            fi
            ;;
        2)
            show_module_info
            ;;
        3)
            show_gm_commands
            ;;
        4)
            show_troubleshooting
            ;;
        5)
            show_main_menu
            return
            ;;
    esac
    
    show_documentation
}

show_module_info() {
    print_header "MODULE INFORMATION"
    
    echo "═══════════════════════════════════════════════════════════"
    echo "1. mod-no-hearthstone-cooldown"
    echo "   Removes 30-minute hearthstone cooldown"
    echo ""
    echo "2. mod-account-mounts"
    echo "   Makes mounts account-wide instead of character-specific"
    echo ""
    echo "3. mod-arac (All Races All Classes)"
    echo "   Allows any race to be any class"
    echo "   Requires Patch-A.MPQ in WoW client"
    echo ""
    echo "4. mod-ah-bot-plus"
    echo "   Auction House Bot - posts items for sale"
    echo "   Requires GUID configuration"
    echo ""
    echo "5. mod-transmog"
    echo "   Transmogrification system for cosmetic appearances"
    echo "   GM Command: .npc add 190010"
    echo ""
    echo "6. mod-aoe-loot"
    echo "   Loot all nearby mobs at once"
    echo ""
    echo "7. mod-solo-lfg"
    echo "   Solo queue for Looking For Group dungeons"
    echo ""
    echo "8. mod-autobalance"
    echo "   Auto-balances dungeon difficulty based on player count"
    echo ""
    echo "9. mod-eluna"
    echo "   Lua scripting engine for custom scripts"
    echo ""
    echo "10. mod-cfbg"
    echo "   Cross-faction battlegrounds"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    read -p "Press Enter to continue..."
}

show_gm_commands() {
    print_header "GM COMMANDS REFERENCE"
    
    echo "═══════════════════════════════════════════════════════════"
    echo "ACCOUNT MANAGEMENT"
    echo "───────────────────"
    echo "account create <user> <pass>    - Create new account"
    echo "account set gmlevel <user> 3 -1 - Make user GM (level 3)"
    echo "account set password <user> <pass> <pass> - Change password"
    echo "account onlinelist              - List online accounts"
    echo ""
    echo "SERVER MANAGEMENT"
    echo "───────────────────"
    echo "server shutdown <seconds>       - Shutdown server"
    echo "server restart <seconds>        - Restart server"
    echo "announce <message>              - Send global announcement"
    echo "notify <message>                - Send notification"
    echo ""
    echo "ITEM COMMANDS"
    echo "───────────────────"
    echo ".add <itemid>                   - Add item to target"
    echo ".additem <itemid>               - Add item to yourself"
    echo ".additemset <setid>             - Add item set"
    echo ".addmoney <amount>              - Add gold"
    echo ""
    echo "CHARACTER COMMANDS"
    echo "───────────────────"
    echo ".level <level>                  - Set level"
    echo ".tele <location>                - Teleport to location"
    echo ".speed <speed>                  - Set speed (1-10)"
    echo ".fly on/off                     - Enable/disable flying"
    echo ".god on/off                     - God mode"
    echo ""
    echo "NPC COMMANDS"
    echo "───────────────────"
    echo ".npc add <id>                   - Spawn NPC"
    echo ".npc del                        - Delete targeted NPC"
    echo ".npc set level <level>          - Set NPC level"
    echo ""
    echo "PLAYERBOT COMMANDS"
    echo "───────────────────"
    echo ".bot add <name>                 - Add bot to group"
    echo ".bot remove <name>              - Remove bot"
    echo ".bot init <name>                - Initialize bot gear"
    echo ".bot spec <spec>                - Set bot specialization"
    echo ""
    echo "DATABASE COMMANDS"
    echo "───────────────────"
    echo "pdump write <file> <char>       - Backup character"
    echo "pdump load <file> <account>     - Restore character"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Note: Use period (.) prefix in-game, no prefix in console"
    echo ""
    read -p "Press Enter to continue..."
}

show_troubleshooting() {
    print_header "TROUBLESHOOTING"
    
    echo "═══════════════════════════════════════════════════════════"
    echo "SERVER WON'T START"
    echo "───────────────────"
    echo "1. Check if ports 3724 and 8085 are available:"
    echo "   netstat -tlnp | grep -E '3724|8085'"
    echo ""
    echo "2. Check MySQL is running:"
    echo "   systemctl status mariadb"
    echo ""
    echo "3. Check logs in:"
    echo "   $INSTALL_DIR/env/dist/bin/"
    echo ""
    echo "RESET ALL BOTS"
    echo "───────────────────"
    echo "1. Edit config: pb"
    echo "2. Set: AiPlayerbot.DeleteRandomBotAccounts = 1"
    echo "3. Start server and wait"
    echo "4. Set back to 0 and restart"
    echo ""
    echo "CLEAN REBUILD"
    echo "───────────────────"
    echo "1. Remove build cache:"
    echo "   rm -rf ~/azerothcore-wotlk/var/build"
    echo "2. Recompile: compile"
    echo ""
    echo "DATABASE RESET"
    echo "───────────────────"
    echo "1. Stop server: stop"
    echo "2. Drop databases:"
    echo "   mysql -u root"
    echo "   DROP DATABASE acore_auth;"
    echo "   DROP DATABASE acore_characters;"
    echo "   DROP DATABASE acore_world;"
    echo "3. Re-run installation"
    echo ""
    echo "COMPILATION ERRORS"
    echo "───────────────────"
    echo "1. Ensure you have enough RAM (4GB minimum)"
    echo "2. Update dependencies: apt update && apt upgrade"
    echo "3. Clean build directory: rm -rf var/build"
    echo "4. Try full recompile: compile"
    echo ""
    echo "CLIENT CONNECTION ISSUES"
    echo "───────────────────"
    echo "1. Check realmlist.wtf has correct IP"
    echo "2. Check firewall isn't blocking ports 3724/8085"
    echo "3. Check router port forwarding (for internet)"
    echo "4. Verify server is running: pgrep worldserver"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    read -p "Press Enter to continue..."
}

# ============================================
# SCRIPT ENTRY POINT
# ============================================

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_debian_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$VERSION_ID" != "13" ]] && [[ "$VERSION_ID" != "trixie" ]]; then
            print_warning "This script is designed for Debian 13 (Trixie)"
            print_warning "Your version: $VERSION_ID"
            if ! ask_yes_no "Continue anyway"; then
                exit 1
            fi
        fi
    fi
}

main() {
    # Check if running as root
    check_root
    
    # Check Debian version
    check_debian_version
    
    # Show main menu
    show_main_menu
}

# Run main function
main "$@"
