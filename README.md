# AzerothCore WoW Server - Debian 13 Automated Installer

[![License: AGPL](https://img.shields.io/badge/License-AGPL-blue.svg)](https://www.azerothcore.org/)
[![Debian](https://img.shields.io/badge/Debian-13-red.svg)](https://www.debian.org/)
[![AzerothCore](https://img.shields.io/badge/AzerothCore-Playerbots-green.svg)](https://www.azerothcore.org/)

> Complete automated installation system for **AzerothCore Wrath of the Lich King (3.3.5a)** with **Playerbots** and all popular modules on **Debian 13 (Trixie)** Linux.

## 📑 Table of Contents

- [Overview](#overview)
- [What's Included](#whats-included)
- [Quick Start](#quick-start)
- [Installation Modes](#installation-modes)
- [Documentation](#documentation)
- [System Requirements](#system-requirements)
- [Features](#features)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Support](#support)
- [License](#license)

## 📖 Overview

This repository provides a **comprehensive automated installation system** for running your own World of Warcraft: Wrath of the Lich King (3.3.5a) private server. Based on the popular [AzerothCore](https://www.azerothcore.org/) emulator with the [Playerbots](https://github.com/mod-playerbots/mod-playerbots) module, this script handles everything from system preparation to server management.

### Why Use This Installer?

- ✅ **Fully Automated** - Complete installation with interactive prompts
- ✅ **All Modules Included** - 10 popular modules ready to install
- ✅ **Playerbots Support** - AI companions (400-1000+ bots)
- ✅ **Debian 13 Optimized** - Specifically designed for Debian Trixie
- ✅ **Production Ready** - Includes database fixes, configurations, and management tools
- ✅ **Well Documented** - Comprehensive guides and references

## 📦 What's Included

### Repository Structure

```
.
├── install-azerothcore.sh     ⭐ Main installation script
├── INSTALL_GUIDE.md           📖 Complete installation guide
├── SCRIPT_SUMMARY.md          📋 Quick reference summary
├── CHOICES.md                 📚 Feature & option reference
├── README.md                  📄 This file
├── build.txt                  📄 Original manual installation guide
└── docker/                    🐳 Docker deployment files
    ├── docker-compose.yml
    ├── Dockerfile
    ├── docker-entrypoint.sh
    └── README.md
```

### Core Components

| Component | Description |
|-----------|-------------|
| **AzerothCore** | World of Warcraft 3.3.5a server emulator |
| **Playerbots** | AI player companions (400-1000+ bots) |
| **MySQL/MariaDB** | Database server for game data |
| **10 Modules** | Additional gameplay features |

### Available Modules

1. **mod-playerbots** (built-in) - AI player companions
2. **mod-no-hearthstone-cooldown** - Instant hearthstone
3. **mod-account-mounts** - Account-wide mounts
4. **mod-arac** - All Races All Classes (Human Druids, etc.)
5. **mod-ah-bot-plus** - Auction House bot
6. **mod-transmog** - Transmogrification system
7. **mod-aoe-loot** - Area of Effect looting
8. **mod-solo-lfg** - Solo dungeon finder
9. **mod-autobalance** - Auto dungeon scaling
10. **mod-eluna** - Lua scripting engine
11. **mod-cfbg** - Cross-faction battlegrounds

## 🚀 Quick Start

### Prerequisites

- Debian 13 (Trixie) Linux
- Root or sudo access
- Internet connection
- Minimum 50GB free disk space

### Installation

```bash
# Download and navigate to the repository
git clone <repository-url>
cd VC-AzerothCore

# Make the script executable
chmod +x install-azerothcore.sh

# Run the installer (must be root)
sudo ./install-azerothcore.sh
```

Then select **Option 1** for "🚀 FULL INSTALL - All Features & Modules"

### What Happens During Installation

1. **System Preparation** - Updates packages, installs prerequisites
2. **Repository Cloning** - Downloads AzerothCore and Playerbots
3. **Dependency Installation** - Installs all required libraries
4. **Module Installation** - Clones all selected modules
5. **Build Configuration** - Configures compiler settings
6. **Compilation** - Builds the server (15-45 minutes)
7. **MySQL Configuration** - Sets up databases and user
8. **Client Data Download** - Downloads game data files
9. **Script Creation** - Creates management scripts
10. **Database Hotfix** - Applies 2026-02-07 workaround
11. **Flying Mount** - Creates custom flying mount item
12. **Admin Account** - Creates your admin account

## 🎯 Installation Modes

### Option 1: Full Install (Recommended)

Installs everything with optimal settings:
- ✅ 500-1000 AI bots
- ✅ All 10 modules
- ✅ All cross-faction features
- ✅ Instant logout, quest tracker
- ✅ Flying mount item
- ✅ PvP server type

### Option 2: Custom Install

Choose your own configuration:
- Select specific modules
- Configure bot counts
- Choose server type (PvE/PvP/RP)
- Enable/disable features
- Set custom IP addresses

### Option 3: Wipe & Reinstall

Clean slate installation:
- Backs up existing data (optional)
- Removes old installation
- Removes databases (optional)
- Fresh install from scratch

### Option 4: Install Modules Only

Add modules to existing installation

### Option 5: Update Existing

Update core and modules without full reinstall

### Option 6: Server Management

Control your running server

### Option 7: Configuration

Edit server settings and configurations

## 📚 Documentation

### File Descriptions

| File | Purpose | When to Read |
|------|---------|--------------|
| **INSTALL_GUIDE.md** | Complete installation guide with all details | Before/during installation |
| **CHOICES.md** | Reference for all installation options | When customizing installation |
| **SCRIPT_SUMMARY.md** | Quick reference of features and usage | Quick lookup |
| **build.txt** | Original manual installation guide | Manual installation reference |
| **docker/README.md** | Docker deployment guide | For containerized deployment |

### Documentation Guide

**New to AzerothCore?**
1. Start with **README.md** (this file)
2. Read **INSTALL_GUIDE.md** for complete details
3. Run the installer and follow prompts

**Want to customize?**
1. Read **CHOICES.md** to understand all options
2. Run installer with "Custom Install" option
3. Select your preferred features

**Need a quick reference?**
1. Check **SCRIPT_SUMMARY.md** for command list
2. Use management aliases after installation

**Interested in Docker?**
1. Read **docker/README.md**
2. Use Docker deployment option

## 💻 System Requirements

### Minimum Requirements

- **OS**: Debian 13 (Trixie) Linux
- **CPU**: Quad-core processor
- **RAM**: 4GB dedicated to server
- **Disk**: 50GB free space
- **Network**: Internet connection for downloads

### Recommended (for 1000+ bots)

- **CPU**: 6+ cores
- **RAM**: 8GB+ dedicated
- **Disk**: 100GB SSD
- **Network**: Stable connection

### Client Requirements

- **WoW Client**: Version 3.3.5a (WotLK)
- **Download**: [ChromieCraft](https://www.chromiecraft.com/en/downloads/) (~17GB)
- **Addons**: UnBot (bot control), TipTac (recommended)

## ✨ Features

### Server Features

- **Multiple Server Types**: Normal, PvP, RP, RP-PvP
- **Cross-Faction Support**: Groups, guilds, chat, auction house
- **Quality of Life**: Instant logout, quest tracker, enhanced visibility
- **Custom Items**: Flying mount (learnable at level 1)
- **Database Hotfix**: Automatic 2026-02-07 workaround

### Management Aliases

After installation, use these shortcuts:

```bash
start      # Start auth & world servers
stop       # Stop all servers
wow        # Attach to world server console
auth       # Attach to auth server console
build      # Incremental compilation
compile    # Full recompilation
update     # Update core + playerbots
updatemods # Update all modules
pb         # Edit playerbots.conf
world      # Edit worldserver.conf
ah         # Edit AH bot config
tm         # Edit transmog config
```

### Network Modes

**LAN Mode:**
- Local network access only
- Use for single-player or LAN parties
- Configure with local IP (e.g., 192.168.1.100)

**Internet Mode:**
- Public server access
- Requires external IP or DDNS
- Port forwarding required (ports 3724, 8085)

## 🎮 Usage

### Starting the Server

```bash
# Start both auth and world servers
start

# Check if running
pgrep authserver
pgrep worldserver
```

### Connecting to Console

```bash
# Connect to world server (use GM commands here)
wow

# Detach from console (press these keys)
CTRL+B, D

# Connect to auth server
auth
```

### Creating Accounts

```bash
# Connect to world server
wow

# Create account
account create username password

# Make account GM (level 3 = full admin)
account set gmlevel username 3 -1

# Detach
CTRL+B, D
```

### Configuring WoW Client

Edit `Data/enUS/realmlist.wtf` in your WoW client:
```
set realmlist YOUR_SERVER_IP
```

### Module Setup

**ARAC (All Races All Classes):**
1. Download `Patch-A.MPQ` from mod-arac repository
2. Place in WoW client `Data` folder

**Auction House Bot:**
1. Create account: `account create ahbot password`
2. Login and create character
3. Get GUID: `lookup player account ahbot`
4. Edit config: `ah`
5. Set `AuctionHouseBot.GUIDs = [your GUID]`

**Transmogrification:**
- In-game: `.npc add 190010`

**Flying Mount:**
- In-game: `.additem 701000`

## 🐛 Troubleshooting

### Server Won't Start

```bash
# Check ports
netstat -tlnp | grep -E '3724|8085'

# Check MySQL
systemctl status mariadb

# View logs
cd ~/azerothcore-wotlk/env/dist/bin
./worldserver
```

### Database Connection Errors

1. Verify MySQL is running
2. Check credentials in config files
3. Verify databases exist: `mysql -u root -e "SHOW DATABASES;"`

### Compilation Errors

```bash
# Clean build directory
rm -rf ~/azerothcore-wotlk/var/build

# Recompile
compile
```

### Reset All Bots

1. Edit config: `pb`
2. Set: `AiPlayerbot.DeleteRandomBotAccounts = 1`
3. Start server, wait 5 minutes
4. Set back to 0 and restart

### Client Can't Connect

1. Verify `realmlist.wtf` has correct IP
2. Check firewall isn't blocking ports
3. Verify router port forwarding (for internet)
4. Check server is running: `pgrep worldserver`

## 📖 GM Commands Reference

### Account Management
```
account create <user> <pass>
account set gmlevel <user> 3 -1
account set password <user> <newpass> <newpass>
account onlinelist
```

### Server Control
```
server shutdown <seconds>
server restart <seconds>
announce <message>
notify <message>
```

### Items & Character
```
.add <itemid>
.additem <itemid>
.level <level>
.tele <location>
.fly on/off
.god on/off
```

### Playerbots
```
.bot add <name>
.bot remove <name>
.bot init <name>
```

## 🤝 Support

- **AzerothCore**: https://www.azerothcore.org/
- **Playerbots**: https://github.com/mod-playerbots/mod-playerbots
- **Modules**: https://www.azerothcore.org/catalogue.html
- **Discord**: Join AzerothCore Discord for support

## 🙏 Credits

- **AzerothCore Team**: For the amazing open-source WoW emulator
- **Playerbots Contributors**: For the AI companion system
- **Module Developers**: For extending AzerothCore functionality
- **WoW Community**: For keeping the game alive

## ⚖️ License

This installation script is provided as-is for educational purposes.

- **AzerothCore**: [AGPL License](https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE)
- **Playerbots**: AGPL License
- **World of Warcraft**: Trademark of [Blizzard Entertainment](https://www.blizzard.com/)

This project is not affiliated with or endorsed by Blizzard Entertainment.

## 📝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 🗺️ Roadmap

- [ ] Support for additional Linux distributions
- [ ] Web-based configuration interface
- [ ] Automated backup system
- [ ] Monitoring dashboard
- [ ] Additional module integrations

---

**Ready to start your own WoW server?**

```bash
sudo ./install-azerothcore.sh
```

🎮 **Happy gaming!**

---

<p align="center">
  <sub>Built with ❤️ for the WoW community</sub>
</p>
