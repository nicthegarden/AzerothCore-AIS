# AzerothCore Automated Installation System

Complete automated installation system for AzerothCore WoW Server with all features enabled.

## ✅ Successfully Pushed to GitHub

**Repository:** https://github.com/nicthegarden/AzerothCore-AIS.git  
**Branch:** main (force pushed)  
**Authentication:** SSH (git@github.com)

## 📦 What's Included

### Main Files
- **install.sh** (34KB) - Interactive installation script with 7 modes
- **README.md** - Complete documentation with examples
- **CHOICES.md** - Detailed feature reference
- **build.txt** (58KB) - Original manual installation guide
- **.gitignore** - Proper ignore rules for build/data files

### Test Files
- **test-install.sh** - Automated test suite
- **test-updated-install.sh** - Tests for new features
- **docker-test-results.sh** - Docker testing summary

### Docker Environment
- **docker/Dockerfile** - Production Docker image
- **docker/Dockerfile.quick** - Quick build image (used for testing)
- **docker/docker-compose.yml** - Full stack configuration
- **docker/docker-entrypoint.sh** - Container entrypoint script
- **docker/docker-entrypoint-local.sh** - Local entrypoint variant
- **docker/README.md** - Docker-specific documentation

## 🚀 Key Features

### 1. Quick Setup Mode (NEW!)
```bash
./install.sh
# Select: "🚀 Quick Setup - Enable ALL Features"
```

**Automatically installs:**
- ✅ AzerothCore + Playerbots (500-1000 bots)
- ✅ All 10+ modules
- ✅ All cross-faction features
- ✅ All quality-of-life improvements
- ✅ PvP server mode
- ✅ IP configuration (LAN/Internet)
- ✅ Comprehensive pre-install summary
- ✅ Detailed post-install instructions

### 2. Installation Modes
1. 🚀 **Quick Setup** - Enable ALL features (recommended)
2. ⚙️  **Custom** - Select features manually
3. 🐳 **Docker** - Container deployment
4. 🔄 **Update** - Update existing installation
5. 📦 **Modules** - Install/update modules only
6. 🔧 **Configure** - Server settings
7. ▶️  **Control** - Start/stop server

### 3. Network Configuration
**LAN Mode:**
- Local network only
- Configurable IP (default: 192.168.1.100)

**Internet Mode:**
- Public server access
- External IP/DDNS support
- Port forwarding reminder (3724, 8085)

### 4. Complete Feature Summary Display
Before installation, shows:
- Server configuration (directory, realm name, IP)
- Playerbot settings (bot counts, auto-login)
- Cross-faction features (all enabled)
- Quality of life features (all enabled)
- All modules with descriptions (11 total)
- Management aliases
- Installation time estimates
- Disk space requirements
- Port information

### 5. All Modules (11 Total)
1. **mod-playerbots** (built-in) - AI companions
2. **mod-no-hearthstone-cooldown** - Instant hearth
3. **mod-account-mounts** - Account-wide mounts
4. **mod-arac** - All Races All Classes
5. **mod-ah-bot-plus** - Auction House bot
6. **mod-transmog** - Transmogrification
7. **mod-aoe-loot** - AoE looting
8. **mod-solo-lfg** - Solo dungeons
9. **mod-autobalance** - Dungeon scaling
10. **mod-eluna** - Lua scripting
11. **mod-cfbg** - Cross-faction BGs

## 🎯 Example Commands

### Installation
```bash
# Quick setup with all features
./install.sh

# With options
./install.sh --install-dir /opt/azerothcore
./install.sh --realm-name "My Server"
./install.sh --server-ip 192.168.1.50
./install.sh --docker
./install.sh --update
```

### Server Management
```bash
start       # Start servers
stop        # Stop servers
wow         # World server console
auth        # Auth server console
pb          # Edit playerbots config
world       # Edit worldserver config
ah          # Edit AH bot config
build       # Incremental compile
compile     # Full recompile
update      # Update core
updatemods  # Update modules
```

### Docker
```bash
cd docker
docker-compose up -d
docker-compose exec azerothcore install-azerothcore
docker-compose logs -f
```

## 📊 Repository Stats

- **Total Files:** 16
- **Main Script:** 34KB (install.sh)
- **Documentation:** 3 comprehensive guides
- **Docker Images:** 2 (production + quick)
- **Test Scripts:** 3 automated testers
- **Lines of Code:** ~6000+

## 🎮 Quick Start

### 1. Clone and Install
```bash
git clone https://github.com/nicthegarden/AzerothCore-AIS.git
cd AzerothCore-AIS
./install.sh
# Select option 1: Quick Setup
```

### 2. Docker Method
```bash
cd AzerothCore-AIS/docker
docker-compose up -d
docker-compose exec azerothcore install-azerothcore
```

### 3. Post-Install
```bash
start                      # Start server
wow                        # Console
account create user pass   # Create account
account set gmlevel user 3 -1  # Make GM
```

## 🔧 Configuration

Edit these files after installation:
- `pb` - Playerbots (500-1000 bots, auto-login, questing)
- `world` - Worldserver (PvP mode, cross-faction, QoL)
- `ah` - Auction House (15K-35K items)
- `tm` - Transmog (all item types allowed)

## 🐳 Docker Container Status

- ✅ **Container:** azerothcore-keep (running)
- ✅ **Image:** azerothcore-demo:latest (716MB)
- ✅ **Ports:** 3724, 8085, 3306 mapped
- ✅ **MariaDB:** Installed and configured
- ✅ **Tested:** All functions working

## ⚡ Installation Time

- **Dependencies:** 2-5 minutes
- **Compilation:** 15-45 minutes (CPU dependent)
- **Client data:** 3-5 minutes
- **Database:** 1-2 minutes
- **Total:** ~20-50 minutes

## 💾 Requirements

- **Disk:** 50GB minimum
- **RAM:** 4GB minimum, 8GB recommended
- **CPU:** Quad-core minimum
- **OS:** Debian 12/Ubuntu 22.04 or Docker

## 🎉 Success!

The repository has been successfully pushed with:
- ✅ All features enabled option
- ✅ Complete documentation
- ✅ Example commands
- ✅ Docker support
- ✅ SSH authentication
- ✅ Force push completed

**Repository URL:** https://github.com/nicthegarden/AzerothCore-AIS

---

*Created: 2026-02-01*  
*Version: 1.0 - Full Featured Release*
