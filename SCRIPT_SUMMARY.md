# AzerothCore Installation Script - Summary

## What Was Created

### 1. install-azerothcore.sh (Main Script)
A comprehensive automation script with 9 main options:

1. **🚀 FULL INSTALL** - All features & modules
2. **⚙️ CUSTOM INSTALL** - Choose your features
3. **🧹 WIPE & REINSTALL** - Clean slate with backup
4. **📦 INSTALL MODULES ONLY** - Add to existing
5. **🔄 UPDATE EXISTING** - Update without reinstall
6. **🎮 SERVER MANAGEMENT** - Start/Stop/Control
7. **🔧 CONFIGURATION** - Edit settings
8. **📖 DOCUMENTATION** - View guides
9. **❌ EXIT**

### 2. INSTALL_GUIDE.md (Documentation)
Complete documentation covering:
- Quick start guide
- All installation modes
- Configuration options
- Management commands
- Module information
- Troubleshooting
- GM commands reference

### 3. CHOICES.md (Reference)
Detailed reference for all choices and options.

### 4. README.md (Overview)
Quick overview and examples.

## Key Features

✅ **Interactive Questions**
- Username/password collection
- Network mode selection (LAN/Internet)
- Module selection
- Feature toggles
- Bot count configuration

✅ **All Modules Supported**
1. No Hearthstone Cooldown
2. Account-Wide Mounts
3. All Races All Classes (ARAC)
4. Auction House Bot
5. Transmogrification
6. AoE Looting
7. Solo LFG
8. Auto Balance
9. Eluna Lua Engine
10. Cross-Faction BGs

✅ **2026-02-07 Database Hotfix**
- Automatic SQL bug workaround
- No manual intervention needed
- Fixes fresh installation issues

✅ **Flying Mount Item**
- Creates item ID 701000
- Learnable at level 1
- Works in all zones

✅ **Management Aliases**
```bash
start      # Start servers
stop       # Stop servers
wow        # World console
auth       # Auth console
build      # Incremental compile
compile    # Full compile
update     # Update core
updatemods # Update modules
pb         # Edit bots config
world      # Edit world config
ah         # Edit AH bot config
tm         # Edit transmog config
```

✅ **Complete Documentation**
- Installation guide
- Module information
- GM commands
- Troubleshooting steps
- Network configuration

## Usage

### Quick Install (All Features)
```bash
cd /mnt/nfs/GIT/VC-AzerothCore
sudo ./install-azerothcore.sh
# Select option 1
```

### Custom Install
```bash
sudo ./install-azerothcore.sh
# Select option 2
# Follow prompts for customization
```

### Wipe and Reinstall
```bash
sudo ./install-azerothcore.sh
# Select option 3
# Optional backup before wipe
```

## What Gets Installed

1. **System Packages**
   - git, curl, unzip, sudo, tmux, nano, net-tools
   - mariadb-server, mariadb-client
   - All AzerothCore build dependencies

2. **AzerothCore**
   - Source code in ~/azerothcore-wotlk
   - Compiled binaries in env/dist/bin
   - Configuration files in env/dist/etc
   - Client data (downloaded automatically)

3. **MySQL Databases**
   - acore_auth (accounts, realms)
   - acore_characters (character data)
   - acore_world (game world data)
   - acore_playerbots (bot data)

4. **Management Scripts**
   - /root/start.sh - Server startup
   - Bash aliases in ~/.bashrc

## Post-Installation

1. **Start Server:**
   ```bash
   start
   ```

2. **Configure Client:**
   Edit `Data/enUS/realmlist.wtf`:
   ```
   set realmlist YOUR_SERVER_IP
   ```

3. **Login with admin account**

4. **Optional Setup:**
   - Install ARAC Patch-A.MPQ (if ARAC enabled)
   - Setup AH Bot character (if AH Bot enabled)
   - Add transmog NPC (if transmog enabled)

## File Locations

- **Main Script:** /mnt/nfs/GIT/VC-AzerothCore/install-azerothcore.sh
- **Documentation:** /mnt/nfs/GIT/VC-AzerothCore/INSTALL_GUIDE.md
- **Installation:** ~/azerothcore-wotlk
- **Configs:** ~/azerothcore-wotlk/env/dist/etc/
- **Binaries:** ~/azerothcore-wotlk/env/dist/bin/
- **Start Script:** /root/start.sh

## Requirements

- **OS:** Debian 13 (Trixie) Linux
- **CPU:** Quad-core minimum
- **RAM:** 4GB minimum (8GB+ recommended)
- **Disk:** 50GB free space
- **Network:** Internet for downloads

## Support

- AzerothCore: https://www.azerothcore.org/
- Playerbots: https://github.com/mod-playerbots/mod-playerbots
- Modules: https://www.azerothcore.org/catalogue.html

---

**Created:** 2026-02-13
**Version:** 2.0 - Enhanced Edition
**Based on:** 2025-2026 AzerothCore + Playerbots Guide
