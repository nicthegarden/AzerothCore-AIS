# AzerothCore Installation Choices Reference

This document details all the choices available in the interactive installation script.

## Installation Modes

When you run `./install.sh`, you can choose from:

1. **Full Installation (Native Linux)**
   - Complete installation on native Linux (Debian/Ubuntu recommended)
   - Includes all build steps, module selection, and configuration
   - Creates management aliases for easy server control

2. **Docker Installation**
   - Containerized deployment for testing/development
   - Uses Debian Trixie base image
   - Pre-configured MariaDB
   - Volume persistence for data

3. **Update Existing Installation**
   - Updates AzerothCore and all modules
   - Option to recompile after update
   - Preserves existing configurations

4. **Install/Update Modules Only**
   - Select from available modules
   - Update existing modules
   - Recompile after module changes

5. **Configure Server Settings**
   - Change realm name
   - Set LAN/Internet IP addresses
   - Configure playerbots
   - Edit world server settings
   - Configure individual modules

6. **Start/Stop Server**
   - Start servers
   - Stop servers
   - Restart servers
   - Attach to world/auth server consoles
   - Create game accounts
   - Check server status

## Module Selection

During installation, you'll be prompted to select modules. Choose by entering space-separated numbers.

### 1. mod-no-hearthstone-cooldown
Removes the 30-minute cooldown on hearthstones.
```
Config file: mod_no_hearthstone_cooldown.conf
```

### 2. mod-account-mounts
Makes mounts account-wide instead of character-specific.
```
Config file: mod_account_mount.conf
Setting: Can enable cross-faction mounts
```

### 3. mod-arac (All Races All Classes)
Allows any race to be any class (e.g., Human Druid, Undead Hunter).
```
Requires: Patch-A.MPQ file in WoW client
SQL: Auto-imported during installation
Config: Database-driven
```

### 4. mod-ah-bot-plus
Auction House Bot that posts items for sale.
```
Config file: mod_ahbot.conf
Setup required:
  1. Create AH bot account
  2. Create AH bot character
  3. Get character GUID
  4. Configure GUID in config
Default: 15,000-35,000 items per faction
```

### 5. mod-transmog
Transmogrification system for cosmetic item appearances.
```
Config file: transmog.conf
Features:
  • Vendor interface option
  • Configurable costs
  • Allow poor/common/uncommon/rare/epic/legendary
  • Mixed armor/weapon types
NPC: .npc add 190010 (GM command)
```

### 6. mod-aoe-loot
Area of Effect looting - loot all nearby mobs at once.
```
Config: Built-in, minimal configuration
```

### 7. mod-solo-lfg
Allows solo queueing for Looking For Group dungeons.
```
Config: Database and core settings
Note: May require dungeon adjustments
```

### 8. mod-autobalance
Automatically balances dungeon difficulty based on player count.
```
Config file: mod_autobalance.conf
Scales: HP, damage, mechanics
```

### 9. mod-eluna
Lua scripting engine for custom scripts.
```
Config: Eluna configuration
Scripts go in: lua_scripts folder
```

### 10. mod-cfbg
Cross-Faction Battlegrounds.
```
Config: Database-driven
Allows: Mixed faction BG teams
```

### Selection Options
- Enter single number (e.g., `5`) for one module
- Enter multiple (e.g., `1 3 5 7`) for several modules
- Enter `11` when done selecting
- Enter `12` to select ALL modules
- Enter `13` to skip (only Playerbots included)

## Build Configuration

### Server Type
Choose your server type:
1. **Normal (PvE)** - PvE ruleset, no world PvP
2. **PvP** - PvP ruleset, world PvP enabled
3. **RP (Roleplay)** - PvE with RP rules
4. **RP-PvP** - PvP with RP rules

### Playerbot Configuration
Set the number of AI bots that roam your world:

**Min/Max Bots:**
- Minimum: 400 (default)
- Maximum: 500 (default)
- Can set: 0 to 4000+ (performance dependent)

**Auto-login:**
- Enable: Bots login automatically at server start
- Disable: Manual bot management

**Bot Features:**
- `AiPlayerbot.AutoDoQuests` - Bots complete quests
- `AiPlayerbot.AutoEquipUpgradeLoot` - Auto-equip better gear
- `AiPlayerbot.RandomBotGroupNearby` - Bots group up
- `AiPlayerbot.AutoTeleportForLevel` - Auto-leveling

### Cross-Faction Settings
Enable cross-faction interactions:

1. **Cross-Faction Grouping**
   - Allow Alliance and Horde to group together

2. **Cross-Faction Guilds**
   - Allow mixed-faction guilds

3. **Cross-Faction Chat**
   - Allow talking across factions

4. **Cross-Faction Auction House**
   - Link all auction houses (Alliance, Horde, Neutral)

### Quality of Life Options

**Instant Logout:**
- Enable: Skip 20-second logout timer
- Disable: Standard logout wait

**Quest Tracker:**
- Enable: Track quest completion
- Disable: No tracking

**Visibility Distance:**
- Default: 90-120 yards
- Can increase for better visibility

**Player Limits:**
- 0: Unlimited
- N: Maximum N players

## Database Configuration

### MySQL Settings
Default credentials:
```
User: acore
Password: acore
Databases:
  - acore_auth (accounts, realms)
  - acore_characters (character data)
  - acore_world (game world data)
  - acore_playerbots (bot data)
```

### Realm Configuration
- **Name:** Your server's display name
- **Address:** IP for connections
  - LAN: Internal IP (e.g., 192.168.1.100)
  - Internet: External IP or DDNS
- **Port:** 8085 (world), 3724 (auth)

## Network Configuration

### LAN Setup
```
Realm Address: 192.168.1.100 (your server IP)
Client realmlist.wtf: set realmlist 192.168.1.100
```

### Internet Setup
```
Realm Address: YOUR_EXTERNAL_IP or DDNS
Port Forwarding Required:
  - 3724 TCP (Auth)
  - 8085 TCP (World)
Client realmlist.wtf: set realmlist YOUR_EXTERNAL_IP
```

## Management Aliases

After installation, these shortcuts are available:

### Server Control
- `start` - Start auth and world servers in tmux
- `stop` - Kill all server processes
- `wow` - Attach to world server console
- `auth` - Attach to auth server console

### Development
- `build` - Incremental compilation (fast)
- `compile` - Full recompilation (clean build)
- `update` - Update AzerothCore + Playerbots
- `updatemods` - Update all installed modules

### Configuration
- `pb` - Edit playerbots.conf
- `world` - Edit worldserver.conf
- `authconf` - Edit authserver.conf
- `ah` - Edit mod_ahbot.conf (if installed)
- `tm` - Edit transmog.conf (if installed)

## Advanced Options

### Docker Environment Variables
```bash
REALM_NAME="My Server Name"
SERVER_IP="192.168.1.100"
ACORE_USER="acore"
ACORE_PASS="acore"
INSTALL_DIR="/azerothcore"
```

### Command Line Arguments
```bash
./install.sh --install-dir /opt/azerothcore
./install.sh --realm-name "My Realm"
./install.sh --server-ip 192.168.1.100
./install.sh --docker
./install.sh --update
./install.sh --start
./install.sh --stop
./install.sh --status
./install.sh --help
```

## Post-Installation Account Creation

After starting the server:

1. Attach to world server:
   ```
   wow
   ```

2. Create account:
   ```
   account create username password
   ```

3. Set GM level (optional):
   ```
   account set gmlevel username 3 -1
   ```
   Levels: 0=Player, 1=Moderator, 2=Game Master, 3=Administrator

4. Detach from tmux:
   ```
   CTRL+B, D
   ```

## Module-Specific Post-Installation

### ARAC Module
1. Download Patch-A.MPQ from mod-arac repository
2. Place in WoW client Data folder
3. Restart WoW client

### AH Bot Module
1. Start server: `start`
2. Attach: `wow`
3. Create account: `account create ahbot password`
4. Login in-game, create character
5. Get GUID: `lookup player account ahbot`
6. Edit config: `ah`
7. Set GUIDs value
8. Restart server

### Transmog Module
1. Start server
2. As GM in-game: `.npc add 190010`
3. Use NPC to transmog items

## Troubleshooting Options

If you encounter issues:

### Reset Bots
```bash
pb  # Edit config
# Set: AiPlayerbot.DeleteRandomBotAccounts = 1
# Start server, wait, set back to 0
```

### Clean Build
```bash
rm -rf ~/azerothcore-wotlk/var/build
compile  # Full recompile
```

### Reset Database
```bash
sudo mysql -u root
DROP DATABASE acore_world;
DROP DATABASE acore_characters;
DROP DATABASE acore_auth;
# Re-run database setup from install script
```

## Example Configurations

### Solo Play (Low Resources)
```
Server Type: Normal (PvE)
Min Bots: 50
Max Bots: 100
Cross-Faction: All enabled
Modules: mod-no-hearthstone-cooldown, mod-account-mounts
```

### Full Experience (High Resources)
```
Server Type: PvP
Min Bots: 1000
Max Bots: 1500
Cross-Faction: None
Modules: ALL modules
QoL: Instant logout enabled
```

### RP Server
```
Server Type: RP or RP-PvP
Min Bots: 200
Max Bots: 300
Cross-Faction: Chat enabled
Modules: mod-transmog, mod-arac
```
