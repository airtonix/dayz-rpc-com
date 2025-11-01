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

Downloads, lists, manages, and builds mods from Steam Workshop and local sources.

### Usage
```bash
./cmd/mods [COMMAND] [ARGS]
```

### Commands
- `new NAME` - Scaffold a new local mod from template
- `build NAME` - Build local mod into PBO using depbo-tools
- `status` - Show configured and installed mods
- `search QUERY` - Search for mods on Steam Workshop
- `install` - Download all enabled mods
- `update` - Update all enabled mods to latest version
- `enable ID NAME` - Enable a mod (add to config)
- `disable NAME` - Disable a mod (remove from config)
- `workbench NAME` - Launch Workbench for a local mod (Windows tools)
- `help` - Show help message

### Examples
```bash
# Show configured and installed mods
./cmd/mods status

# Create a new local mod
./cmd/mods new mymod

# Build local mod into PBO
./cmd/mods build mymod

# Search for mods on Steam Workshop
./cmd/mods search "expansion"

# Download all enabled mods from config
./cmd/mods install

# Update all mods to latest version
./cmd/mods update

# Enable a new mod from Steam Workshop
./cmd/mods enable 1234567890 @my-mod

# Disable a mod
./cmd/mods disable @my-mod
```

### Local Mod Development

#### Creating a New Mod
```bash
# Create mod from template
./cmd/mods new mymod

# This creates:
# - pkgs/mymod/            - Mod source directory
# - pkgs/mymod/Scripts/    - Script files organized by module
# - mods/@mymod/           - Symlink to source for development
```

#### Building a Mod
```bash
# Build the mod into PBO format with versioning
./cmd/mods build mymod

# Output includes:
# - Versioned PBO: addons/MyMod-1.0.0.pbo
# - Metadata: version.txt (JSON with commit, buildtime)
# - Manifest: mod.cpp (mod metadata)
# - Keys: keys/ directory (if signing keys present)
# - Symlink: mods/@mymod (ready for server)
```

#### Requirements for Building
- Docker with `jerryhopper/depbo-tools` image
- Source mod in `pkgs/mod-name/` directory
- Valid `config.cpp` and `$PBOPREFIX$` file
- Optional: version file, git tags, or package.json for versioning

#### Build Output
Built mods are placed in:
```
build/@modname/
├── addons/
│   └── modname-1.0.0.pbo      - Versioned PBO archive
├── keys/                        - Signing keys (optional)
├── mod.cpp                      - Mod metadata
└── version.txt                  - Version metadata (JSON)

mods/@modname/ → ../build/@modname/  - Symlink (ready for server)
```

See [Build Output Documentation](build-output.md) for detailed structure and versioning information.

### Mod Configuration

Mods are defined in `config/mods.json`:
```json
{
  "mods": [
    {
      "id": 1559212036,
      "name": "@cf",
      "title": "Community Framework"
    }
  ]
}
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
4. Use this ID in `config/mods.json`

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

### Mod Workflow
```bash
# 1. Enable a mod (add to config)
./cmd/mods enable 2116151222 @de

# 2. Download it
./cmd/mods install

# 3. Restart server (config is auto-synced)
./cmd/server restart
```

---

## Build Validation - ./cmd/build-validate

Validates that all local build tools are properly installed and functional using bats test framework.

### Usage
```bash
eval "$(mise activate bash)"
bats tests/cmd-mods.bats
```

### Test Cases (bats)
The test suite includes 11 comprehensive tests:
- Docker daemon availability
- depbo-tools Docker image availability
- makepbo PBO file creation
- PBO file validity (size check)
- extractpbo PBO extraction
- extractpbo file preservation (config.cpp)
- rapify config binarization
- Binary config validity (size check)
- cmd/mods build command existence
- Absolute path handling with docker_makepbo
- Absolute path handling with docker_extractpbo

### Bats Output
```
1..11
ok 1 docker is available
ok 2 depbo-tools image is available
ok 3 makepbo creates PBO file
ok 4 makepbo output is valid PBO
ok 5 extractpbo extracts PBO contents
ok 6 extractpbo preserves config.cpp
ok 7 rapify creates binary config
ok 8 rapify output is valid binary
ok 9 cmd/mods build command exists
ok 10 docker_makepbo with absolute paths
ok 11 docker_extractpbo with absolute output path
```

### Requirements
- Docker (for depbo-tools backend)
- bats test framework (via mise)
- Linux/macOS or WSL2 on Windows

### Troubleshooting

If Docker is not available:
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

If Docker daemon is not running:
```bash
# Start Docker daemon
sudo systemctl start docker
# Or on macOS
open -a Docker
```
