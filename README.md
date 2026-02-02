# AzerothCore WoW Server - Automated Installation System

Complete automated installation and management system for AzerothCore WoW Server with Playerbots and all popular modules.

## 🚀 Quick Start (All Features Enabled)

```bash
./install.sh
# Select option 1: "Quick Setup - Enable ALL Features"
```

This installs **everything** automatically:
- ✅ AzerothCore + Playerbots
- ✅ All 10+ modules
- ✅ 500-1000 AI bots
- ✅ All cross-faction features
- ✅ All quality-of-life improvements
- ✅ PvP server mode

## 📦 What's Included

### Core Features
- **AzerothCore WotLK**: World of Warcraft 3.3.5a server
- **Playerbots**: AI companions (500-1000 bots)
- **Full Module Suite**: 10 additional modules
- **Cross-Faction**: All features enabled
- **Auto-Configuration**: IP, database, configs

### Modules (11 Total)
1. **mod-playerbots** (built-in) - AI player companions
2. **mod-no-hearthstone-cooldown** - Instant hearthstone
3. **mod-account-mounts** - Account-wide mounts
4. **mod-arac** - All Races All Classes
5. **mod-ah-bot-plus** - Auction House bot (15K-35K items)
6. **mod-transmog** - Transmogrification system
7. **mod-aoe-loot** - Area of Effect looting
8. **mod-solo-lfg** - Solo dungeon finder
9. **mod-autobalance** - Auto dungeon scaling
10. **mod-eluna** - Lua scripting engine
11. **mod-cfbg** - Cross-faction battlegrounds

## 🎯 Installation Modes

### Option 1: Quick Setup (RECOMMENDED)
```bash
./install.sh
# Select: 🚀 Quick Setup - Enable ALL Features
```

**What it does:**
- Auto-selects all modules
- Configures optimal settings
- Sets up 500-1000 bots
- Enables all cross-faction features
- Prompts for IP configuration
- Shows complete summary before install

### Option 2: Custom Installation
```bash
./install.sh
# Select: ⚙️ Custom Installation - Select Features Manually
```

**Choose your own:**
- Specific modules
- Bot counts
- Server type (PvE/PvP/RP)
- Cross-faction options
- Quality-of-life features

### Option 3: Docker Installation
```bash
./install.sh
# Select: 🐳 Docker Installation - Container Setup
```

Or use Docker directly:
```bash
cd docker
docker-compose up -d
docker-compose exec azerothcore install-azerothcore
```

## 🌐 Network Configuration

### LAN Mode (Local Network)
```
Server IP: 192.168.1.100 (configurable)
Access: Local network only
Ports: 3724 (auth), 8085 (world)
Client realmlist.wtf: set realmlist 192.168.1.100
```

### Internet Mode (Public Server)
```
Server IP: YOUR_EXTERNAL_IP or DDNS
Access: Worldwide
Requires: Port forwarding 3724 & 8085
Client realmlist.wtf: set realmlist YOUR_EXTERNAL_IP
```

## 📋 Example Commands

### Installation
```bash
# Interactive installation with all features
./install.sh

# Command-line options
./install.sh --install-dir /opt/azerothcore
./install.sh --realm-name "My Server"
./install.sh --server-ip 192.168.1.50
./install.sh --docker
./install.sh --update
./install.sh --help
```

### Server Management (after install)
```bash
# Start servers
start

# Stop servers  
stop

# Attach to world server console
wow

# Attach to auth server console
auth

# Edit configurations
pb          # Playerbots config
world       # Worldserver config
ah          # AH bot config (if installed)
tm          # Transmog config (if installed)

# Development
build       # Incremental compile (fast)
compile     # Full recompile (clean build)
update      # Update core + playerbots
updatemods  # Update all modules
```

### Docker Commands
```bash
# Build and start
cd docker
docker-compose up -d

# View logs
docker-compose logs -f

# Execute installation in container
docker-compose exec azerothcore install-azerothcore

# Open shell
docker-compose exec azerothcore /bin/bash

# Start servers in container
docker-compose exec azerothcore /docker-entrypoint.sh start

# Stop
docker-compose down
```

## 🎮 Post-Installation Setup

### 1. Start Server
```bash
start
```

### 2. Create Admin Account
```bash
wow
# In world server console:
account create admin mypassword
account set gmlevel admin 3 -1
```

### 3. Configure WoW Client
Edit `Data/enUS/realmlist.wtf`:
```
set realmlist YOUR_SERVER_IP
```

### 4. ARAC Module (Optional)
Download `Patch-A.MPQ` from mod-arac repo and place in WoW client `Data` folder.

## 🔧 Configuration Files

After installation, edit these files to customize:

| File | Command | Purpose |
|------|---------|---------|
| `worldserver.conf` | `world` | Server type, rates, limits |
| `playerbots.conf` | `pb` | Bot counts, behavior |
| `mod_ahbot.conf` | `ah` | Auction house settings |
| `transmog.conf` | `tm` | Transmog rules |

## 📊 System Requirements

### Minimum
- **CPU**: Quad-core
- **RAM**: 4GB dedicated
- **Disk**: 50GB free space
- **OS**: Debian 12/Ubuntu 22.04 or Docker

### Recommended (for 1000 bots)
- **CPU**: 6+ cores
- **RAM**: 8GB+ dedicated
- **Disk**: 100GB SSD
- **Network**: Stable connection

## 🐛 Troubleshooting

### Server won't start
```bash
# Check status
./install.sh --status

# View logs
cd ~/azerothcore-wotlk/env/dist/bin
./worldserver
```

### Reset all bots
```bash
pb
# Set: AiPlayerbot.DeleteRandomBotAccounts = 1
# Start server, wait, set back to 0
```

### Clean rebuild
```bash
rm -rf ~/azerothcore-wotlk/var/build
compile
```

### Docker issues
```bash
# Reset everything
docker-compose down -v
docker-compose up -d
```

## 📚 Documentation

- **CHOICES.md**: Complete feature reference
- **docker/README.md**: Docker-specific guide
- **build.txt**: Original manual installation guide

## 🤝 Support

- AzerothCore: https://www.azerothcore.org/
- Playerbots: https://github.com/mod-playerbots/mod-playerbots
- Modules: https://www.azerothcore.org/catalogue.html

## ⚖️ License

This installation script is provided as-is for educational purposes. AzerothCore is AGPL licensed. World of Warcraft is a trademark of Blizzard Entertainment.

---

**Quick Install Today:**
```bash
cd /mnt/nfs/GIT/VC-AzerothCore
./install.sh
# Select option 1
```
