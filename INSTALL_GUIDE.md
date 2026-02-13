# AzerothCore WoW Server - Automated Installation Script

## Overview

This is a comprehensive automation script for installing **AzerothCore Wrath of the Lich King (3.3.5a)** server with **Playerbots** and all popular modules on **Debian 13 (Trixie)** Linux.

### What's Included

✅ **Complete AzerothCore Installation**
- AzerothCore WotLK server
- Playerbots module (AI companions)
- All dependencies and configurations
- Automatic database setup
- Management scripts and aliases

✅ **All Popular Modules**
1. mod-no-hearthstone-cooldown - Instant hearthstone
2. mod-account-mounts - Account-wide mounts
3. mod-arac - All Races All Classes (Human Druid, etc.)
4. mod-ah-bot-plus - Auction House bot
5. mod-transmog - Transmogrification system
6. mod-aoe-loot - Area of Effect looting
7. mod-solo-lfg - Solo dungeon finder
8. mod-autobalance - Auto dungeon scaling
9. mod-eluna - Lua scripting engine
10. mod-cfbg - Cross-faction battlegrounds

✅ **2026-02-07 Database Hotfix**
- Automatic workaround for SQL bug
- Fixes fresh installation issues
- No manual intervention needed

✅ **Flying Mount Item**
- Level 1 learnable flying mount
- Works in all zones
- Custom item ID 701000

## Quick Start

### Full Installation (All Features)

```bash
cd /mnt/nfs/GIT/VC-AzerothCore
sudo ./install-azerothcore.sh
# Select option 1: "FULL INSTALL - All Features & Modules"
```

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

## Installation Modes

### Option 1: Full Install (Recommended)

Installs everything with optimal settings:
- 500-1000 AI bots
- All 10 modules
- All cross-faction features enabled
- Instant logout
- Quest tracker
- Flying mount
- PvP server type

### Option 2: Custom Install

Choose your own configuration:
- Select specific modules
- Configure bot counts
- Choose server type (PvE/PvP/RP/RP-PvP)
- Enable/disable features
- Set custom IP addresses

### Option 3: Wipe & Reinstall

Clean slate installation:
- Backs up existing data (optional)
- Removes old installation
- Removes databases (optional)
- Fresh install from scratch

### Option 4: Install Modules Only

Add modules to existing installation:
- Select specific modules
- Automatically clones repositories
- Copies SQL files
- Option to recompile

### Option 5: Update Existing

Update without full reinstall:
- Updates AzerothCore source
- Updates Playerbots module
- Updates all installed modules
- Option to recompile

### Option 6: Server Management

Control your server:
- Start/Stop/Restart
- Attach to consoles
- Check status
- Create accounts

### Option 7: Configuration

Edit settings:
- Change realm name
- Set IP addresses
- Edit config files
- Modify module settings

## Configuration Options

### Admin Account

During installation, you'll be asked for:
- **Username** - Your admin account name
- **Password** - Your admin password
- **GM Level** - Automatically set to 3 (Full Administrator)

### MySQL Credentials

Default credentials (can be customized):
- **Username:** acore
- **Password:** acore
- **Databases:** acore_auth, acore_characters, acore_world, acore_playerbots

### Network Modes

**LAN Mode (Option 1):**
- Local network access only
- Single-player or LAN parties
- Use local IP (e.g., 192.168.1.100)

**Internet Mode (Option 2):**
- Public server access
- External IP or DDNS required
- Port forwarding required (3724, 8085)

### Server Types

1. **Normal (PvE)** - No world PvP
2. **PvP** - World PvP enabled ⭐ Recommended
3. **RP** - Roleplay rules
4. **RP-PvP** - Roleplay with PvP

### Bot Configuration

**Min/Max Bots:**
- Default: 400-500 bots
- Full Install: 500-1000 bots
- Maximum: 4000+ (hardware dependent)

**Auto-Login:**
- Bots automatically login at startup
- Creates living world immediately
- Can be disabled for manual control

### Feature Flags

**Cross-Faction Features:**
- Groups - Allow Alliance/Horde grouping
- Guilds - Mixed-faction guilds
- Chat - Cross-faction communication
- Auction House - Linked auction houses

**Quality of Life:**
- Instant Logout - Skip 20-second wait
- Quest Tracker - Track quest completion
- Flying Mount - Level 1 flying item

## Management Commands

After installation, these shortcuts are available:

### Server Control
```bash
start      # Start auth & world servers
stop       # Stop all servers
wow        # Attach to world server console
auth       # Attach to auth server console
```

### Development
```bash
build      # Incremental compilation (fast)
compile    # Full recompilation (clean build)
update     # Update core + playerbots
updatemods # Update all modules
```

### Configuration
```bash
pb         # Edit playerbots.conf
world      # Edit worldserver.conf
authconf   # Edit authserver.conf
ah         # Edit mod_ahbot.conf (if installed)
tm         # Edit transmog.conf (if installed)
```

## Module Information

### mod-no-hearthstone-cooldown

Removes the 30-minute cooldown on hearthstones.

**Config File:** `mod_no_hearthstone_cooldown.conf`

### mod-account-mounts

Makes mounts account-wide instead of character-specific.

**Config File:** `mod_account_mount.conf`

### mod-arac (All Races All Classes)

Allows any race to be any class:
- Human Druid
- Undead Hunter
- Gnome Paladin
- etc.

**Requirements:**
- Patch-A.MPQ file in WoW client Data folder
- Download from: https://github.com/heyitsbench/mod-arac

### mod-ah-bot-plus

Auction House Bot that posts items for sale.

**Setup Required:**
1. Start server
2. Create AH bot account: `account create ahbot password`
3. Login and create character
4. Get character GUID: `lookup player account ahbot`
5. Edit config: `ah`
6. Set `AuctionHouseBot.GUIDs = [your GUID]`

**Config File:** `mod_ahbot.conf`

### mod-transmog

Transmogrification system for cosmetic item appearances.

**In-Game Usage:**
- Spawn NPC: `.npc add 190010`
- Use NPC to transmog items
- Supports all item qualities

**Config File:** `transmog.conf`

### mod-aoe-loot

Area of Effect looting - loot all nearby mobs at once.

No configuration required.

### mod-solo-lfg

Allows solo queueing for Looking For Group dungeons.

### mod-autobalance

Automatically balances dungeon difficulty based on player count.

**Config File:** `mod_autobalance.conf`

### mod-eluna

Lua scripting engine for custom scripts.

Scripts go in: `lua_scripts` folder

### mod-cfbg

Cross-Faction Battlegrounds - allows mixed faction teams.

## Post-Installation Steps

### 1. Start the Server

```bash
start
```

### 2. Connect to Console (Optional)

```bash
wow
```

Press `CTRL+B, D` to detach.

### 3. Configure WoW Client

Edit `Data/enUS/realmlist.wtf`:
```
set realmlist YOUR_SERVER_IP
```

### 4. Install ARAC Patch (If Enabled)

1. Download `Patch-A.MPQ` from mod-arac repository
2. Place in WoW client `Data` folder
3. Restart WoW client

### 5. Setup AH Bot (If Enabled)

1. Start server: `start`
2. Attach: `wow`
3. Create account: `account create ahbot YourPassword`
4. Login in-game with ahbot account
5. Create character (this will be the seller name)
6. Get GUID: `lookup player account ahbot`
7. Edit config: `ah`
8. Set `AuctionHouseBot.GUIDs = [GUID from step 6]`
9. Restart server

### 6. Add Transmog NPC (If Enabled)

In-game GM command:
```
.npc add 190010
```

### 7. Get Flying Mount (If Enabled)

In-game GM command:
```
.additem 701000
```

Use the item to learn flying (works at level 1).

## Client Requirements

### WoW Client
- **Version:** 3.3.5a (WotLK)
- **Download:** https://www.chromiecraft.com/en/downloads/
- **Size:** ~17GB

### Recommended Addons

**Required:**
- UnBot - Bot control addon
  - https://github.com/noisiver/unbot-addon/tree/english

**Recommended:**
- TipTac - Enhanced tooltips
- VoiceOver - AI quest narration

### Client Patches (Recommended)

**Camera/Mouse Fix:**
- Fixes camera jerking bug
- https://github.com/brndd/vanilla-tweaks/issues/17

**Security Patch:**
- Fixes Remote Code Exploit (RCE)
- https://github.com/stoneharry/RCEPatcher/

## System Requirements

### Minimum
- **CPU:** Quad-core
- **RAM:** 4GB dedicated
- **Disk:** 50GB free space
- **OS:** Debian 13 (Trixie)

### Recommended (1000+ bots)
- **CPU:** 6+ cores
- **RAM:** 8GB+ dedicated
- **Disk:** 100GB SSD
- **Network:** Stable connection

## Network Configuration

### Port Forwarding (Internet Mode)

Forward these ports to your server IP:
- **3724 TCP** - Auth Server
- **8085 TCP** - World Server

### Firewall Rules

```bash
# Allow AzerothCore ports
iptables -A INPUT -p tcp --dport 3724 -j ACCEPT
iptables -A INPUT -p tcp --dport 8085 -j ACCEPT
```

## Troubleshooting

### Server Won't Start

1. Check ports are available:
   ```bash
   netstat -tlnp | grep -E '3724|8085'
   ```

2. Check MySQL:
   ```bash
   systemctl status mariadb
   ```

3. Check logs:
   ```bash
   cd ~/azerothcore-wotlk/env/dist/bin
   ./worldserver
   ```

### Database Connection Errors

1. Verify MySQL is running
2. Check credentials in configs
3. Verify databases exist:
   ```bash
   mysql -u root -e "SHOW DATABASES;"
   ```

### Compilation Errors

1. Clean build directory:
   ```bash
   rm -rf ~/azerothcore-wotlk/var/build
   ```

2. Ensure sufficient RAM (4GB minimum)

3. Update system:
   ```bash
   apt update && apt upgrade
   ```

### Reset All Bots

1. Edit config:
   ```bash
   pb
   ```

2. Set:
   ```
   AiPlayerbot.DeleteRandomBotAccounts = 1
   ```

3. Start server, wait 5 minutes

4. Set back to 0 and restart

### Client Can't Connect

1. Verify realmlist.wtf has correct IP
2. Check firewall isn't blocking
3. Verify router port forwarding (internet)
4. Check server is running:
   ```bash
   pgrep worldserver
   ```

## GM Commands Reference

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

### Items
```
.add <itemid>
.additem <itemid>
.additemset <setid>
.addmoney <amount>
```

### Character
```
.level <level>
.tele <location>
.speed <speed>
.fly on/off
.god on/off
```

### Playerbots
```
.bot add <name>
.bot remove <name>
.bot init <name>
.bot spec <spec>
```

## Important Notes

⚠️ **First Start:**
- Server takes longer on first start (database initialization)
- Be patient and wait for "AzerothCore rev." message

⚠️ **Compilation Time:**
- Depends heavily on CPU
- Can take 15-45 minutes
- Monitor progress in terminal

⚠️ **Disk Space:**
- Ensure 50GB+ free space
- Compilation creates large temporary files

⚠️ **Memory:**
- 4GB minimum recommended
- 8GB+ for 1000+ bots
- Use swap if needed

⚠️ **Backups:**
- Regularly backup databases
- Character backups: `pdump write <file> <char>`
- Full DB backup before major updates

## Database Hotfix (2026-02-07)

This script automatically handles the SQL bug that affects fresh installations:

**What it does:**
1. Temporarily renames problematic SQL file
2. Starts server for initial database creation
3. Re-enables SQL file after startup
4. Applies the SQL fix

**You don't need to do anything** - it's fully automated!

## Support & Resources

- **AzerothCore:** https://www.azerothcore.org/
- **Playerbots:** https://github.com/mod-playerbots/mod-playerbots
- **Modules:** https://www.azerothcore.org/catalogue.html
- **Guide:** https://www.azerothcore.org/wiki/faq

## License

This installation script is provided as-is for educational purposes.

- **AzerothCore:** AGPL License
- **Playerbots:** AGPL License
- **World of Warcraft:** Trademark of Blizzard Entertainment

---

**Ready to install?**

```bash
sudo ./install-azerothcore.sh
```

Select option 1 for full installation with all features! 🚀
