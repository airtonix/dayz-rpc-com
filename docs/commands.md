# Command Tools Reference

DayZ server management is done using the command tools in the `cmd/` directory.

## Installation - ./cmd/install

Installs the DayZ server and optionally downloads mods.

### Usage
```bash
./cmd/install [OPTIONS]
```

### Options
- `--stable` - Install stable DayZ server (default)
- `--experimental` - Install experimental DayZ server
- `--with-mods` - Prompt to install mods after server setup
- `--systemd` - Automatically create systemd service for auto-start
- `--help` - Show help message

### What It Does
1. Checks system requirements (curl, tar, SteamCMD)
2. Installs SteamCMD if not found
3. Creates directory structure (mods/, keys/, logs/, etc.)
4. Downloads DayZ server files via SteamCMD (~50GB)
5. Sets up configuration files
6. Optionally downloads configured mods
7. Optionally creates systemd service for auto-start

### Examples
```bash
# Standard installation (recommended)
./cmd/install

# Install with systemd service for auto-start
./cmd/install --systemd

# Install and prompt for mods
./cmd/install --with-mods

# Install with mods and systemd
./cmd/install --with-mods --systemd
```

### Requirements
- Valid Steam credentials (prompted during installation)
- Steam account with DayZ server license
- ~100GB free disk space

---

## Mod Management - ./cmd/mods

Downloads, lists, and manages mods from Steam Workshop.

### Usage
```bash
./cmd/mods [COMMAND] [ARGS]
```

### Commands
- `list` - List configured mods
- `install` - Download and install all configured mods
- `update` - Update all installed mods to latest version
- `add ID NAME` - Add a new mod to config
- `remove NAME` - Remove a mod from config
- `help` - Show help message

### Examples
```bash
# List configured mods
./cmd/mods list

# Install all mods from config
./cmd/mods install

# Update all mods to latest version
./cmd/mods update

# Add a new mod
./cmd/mods add 1234567890 @my-mod

# Remove a mod
./cmd/mods remove @my-mod
```

### Mod Configuration

Mods are defined in `config/mods.cfg`:
```bash
MOD_LIST=(
    [STEAM_ID]="@folder-name"
    [1559212036]="@cf"
)
```

The script will:
1. Download from Steam Workshop
2. Copy to `mods/@folder-name/`
3. Extract `.bikey` files to `keys/`
4. Convert filenames to lowercase

### Finding Mod IDs

1. Visit Steam Workshop: https://steamcommunity.com/app/221100/workshop/
2. Find mod page
3. The URL contains the ID: `...?id=1234567890`
4. Use this ID in `config/mods.cfg`

---

## Server Control - ./cmd/server

Starts, stops, and manages the running DayZ server.

### Usage
```bash
./cmd/server [COMMAND] [OPTIONS]
```

### Commands
- `start` - Start server in background
- `stop` - Stop server gracefully
- `status` - Check server status
- `restart` - Restart server
- `update` - Update server files
- `logs-tail` - Monitor logs in real-time
- `logs` - View all logs

### Options
- `--debug` - Run server in foreground with debug output

### Examples
```bash
# Start in background
./cmd/server start

# Start in foreground with debug output
./cmd/server start --debug

# Check server status
./cmd/server status

# Stop the server gracefully
./cmd/server stop

# Restart the server
./cmd/server restart

# Update server files
./cmd/server update

# Monitor logs in real-time
./cmd/server logs-tail
```

### Server Startup
The server reads from `config/serverDZ.cfg`:
- Server hostname, port, difficulty
- Mod directories from `modDirs[]`
- Other gameplay settings

### Logs
Server logs are written to:
- `logs/server.log` - Main server output
- `logs/server.pid` - Process ID file
- `logs/server-status.txt` - Connection info

Monitor with:
```bash
tail -f logs/server.log
```

---

## Command Chaining Examples

### Full Setup From Scratch
```bash
# 1. Install server
./cmd/install

# 2. Download mods
./cmd/mods install

# 3. Start server
./cmd/server start

# 4. Monitor logs
./cmd/server logs-tail

# 5. Stop server (in another terminal)
./cmd/server stop
```

### Update Workflow
```bash
# 1. Stop server
./cmd/server stop

# 2. Update server files
./cmd/server update

# 3. Update mods
./cmd/mods update

# 4. Start server again
./cmd/server start
```

### Mod Addition Workflow
```bash
# 1. Add mod to config
./cmd/mods add 2116151222 @de

# 2. Download it
./cmd/mods install

# 3. Restart server (config is auto-synced)
./cmd/server restart
```
