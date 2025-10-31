# DayZ Server and Mods Installation Guide

Complete guide to installing and managing DayZ servers and mods using this setup.

## Quick Start

### 1. Install Server (Stable)

```bash
./cmd/install
```

**What this does:**
- Checks for required tools (SteamCMD, curl, tar)
- Creates directory structure
- Downloads DayZ server via SteamCMD
- Sets up configuration files
- Optionally creates systemd service

### 2. Configure Mods

Edit `config/mods.json` to add your mods:

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

Each mod entry requires the Steam Workshop ID, mod folder name, and title.

### 3. Install Mods

```bash
./cmd/mods install
```

### 4. Start Server

```bash
./cmd/server start
```

---

## Detailed Installation

### Option A: Stable Server

For production/stable version:

```bash
./cmd/install
```

### Option B: Experimental Server

For testing/development:

```bash
./cmd/install --experimental
```

### Option C: Install with Mods

Install server and mods in one go:

```bash
./cmd/install --with-mods
```

---

## Mod Management

### List Configured Mods

```bash
./cmd/mods list
```

### Add a Mod

```bash
./cmd/mods add 1559212036 '@cf'
```

### Remove a Mod

```bash
./cmd/mods remove '@cf'
```

### Install Configured Mods

```bash
./cmd/mods install
```

This will:
1. Prompt for Steam credentials
2. Download mods via SteamCMD from Steam Workshop
3. Copy mods to `mods/` directory
4. Convert filenames to lowercase (compatibility)
5. Extract signing keys to `keys/` directory

### Update All Mods

```bash
./cmd/mods update
```

Output:
```
========================================
Configured Mods
========================================

1. @cf (ID: 1559212036)
   Status: [NOT INSTALLED]
2. @cot (ID: 1564026768)
   Status: [NOT INSTALLED]

Total: 2 mod(s)
```

### Add a Mod

```bash
./scripts/install-mods.sh --add 1559212036 '@cf'
```

Or using Makefile:
```bash
make add-mod ID=1559212036 NAME=@cf
```

### Remove a Mod

```bash
./scripts/install-mods.sh --remove '@cf'
```

Or:
```bash
make remove-mod NAME=@cf
```

### Install Configured Mods

```bash
./scripts/install-mods.sh --install
```

This will:
1. Prompt for Steam credentials
2. Download mods via SteamCMD from Steam Workshop
3. Copy mods to `mods/` directory
4. Convert filenames to lowercase (compatibility)
5. Extract signing keys to `keys/` directory

### Update All Mods

```bash
./scripts/install-mods.sh --update
```

---

## File Structure

```
dayz-server/
├── cmd/
│   ├── install              # Install DayZ server
│   ├── mods                 # Manage mods
│   └── server               # Control server
├── config/
│   ├── serverDZ.cfg         # Main server config
│   ├── mission.xml          # Mission configuration
│   ├── types.xml            # Item definitions
│   └── mods.cfg             # Mod configuration
├── server/                  # DayZ server installation
├── mods/                    # Installed mods
├── keys/                    # Mod signing keys
├── logs/                    # Server logs
├── docs/                    # Documentation
└── README.md                # Quick start guide
```

---

## Configuration

### Edit Server Config

Edit `config/serverDZ.cfg`:

```bash
hostname = "My DayZ Server";
maxPlayers = 60;
difficulty = "hard";
serverTime = "10:00";
```

For detailed options, see [CONFIG_GUIDE.md](CONFIG_GUIDE.md)

### Edit Mod Config

Edit `config/mods.cfg` to add/remove mods. Format:

```bash
declare -A MOD_LIST
MOD_LIST=(
    [WORKSHOP_ID]="@mod_folder_name"
)
```

### Add Mods to Server Config

After installing mods, ensure `config/serverDZ.cfg` references them:

```bash
modDirs[] = {
    "mods/@cf",
    "mods/@cot"
};
```

---

## Server Lifecycle

### Start Server

```bash
./cmd/server start
```

### Monitor Logs

```bash
# Follow in real-time
./cmd/server logs-tail
```

### Stop Server

```bash
./cmd/server stop
```

### Restart Server

```bash
./cmd/server restart
```

### Update Server Files

```bash
./cmd/server update
```

---

## Troubleshooting

### SteamCMD Not Found

Install manually:
```bash
mkdir -p ~/.local/share/steamcmd
cd ~/.local/share/steamcmd
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
mkdir -p ~/.local/bin
ln -s ~/.local/share/steamcmd/steamcmd.sh ~/.local/bin/steamcmd
```

### Steam Credentials Required

The scripts will prompt for credentials when needed. For automation:

```bash
export STEAMCMD_USERNAME="your_username"
export STEAMCMD_PASSWORD="your_password"
./scripts/install-server.sh
```

### Mods Not Loading

1. Check `mods/` directory exists with mod folders: `./cmd/mods list`
2. Verify mod names in `config/serverDZ.cfg` match folder names
3. Check mod signing keys in `keys/` directory
4. Review server logs: `./cmd/server logs-tail`

### Server Won't Start

1. Check server files installed: `ls server/DayZServer`
2. Verify permissions: `ls -la server/`
3. Review logs: `./cmd/server logs-tail`

### Mod Download Failed

1. Verify Steam credentials are correct
2. Check Workshop ID is valid
3. Ensure Steam account has access to mod
4. Check network connectivity

---

## Advanced Usage

### Install Multiple Mod Packs

Create separate `mods.cfg` files:

```bash
# For stable server
cp config/mods.cfg config/mods-stable.cfg
# Edit config/mods-stable.cfg

# For experimental
cp config/mods.cfg config/mods-experimental.cfg
# Edit config/mods-experimental.cfg
```

### Automate Installation

```bash
#!/bin/bash
cd ~/dayz-server

# Install stable server with mods
./cmd/install --with-mods

# Start server
./cmd/server start
```

### Backup Mods

```bash
tar -czf backups/mods-backup.tar.gz mods/ keys/
```

### Restore Mods

```bash
tar -xzf backups/mods-backup.tar.gz
```

---

## Performance Tips

- Monitor mods: `./cmd/server logs-tail`
- Check memory: `ps aux | grep DayZServer`
- Limit mods to essentials only
- Use systemd service for auto-restart

---

## Summary of Commands

| Task | Command |
|------|---------|
| Install stable server | `./cmd/install` |
| Install experimental | `./cmd/install --experimental` |
| List mods | `./cmd/mods list` |
| Add mod | `./cmd/mods add ID @name` |
| Install mods | `./cmd/mods install` |
| Update mods | `./cmd/mods update` |
| Start server | `./cmd/server start` |
| Stop server | `./cmd/server stop` |
| View logs | `./cmd/server logs-tail` |
| Update server | `./cmd/server update` |

---

## References

- **DayZ Wiki**: https://dayz.gamepedia.com/
- **Steam Workshop**: https://steamcommunity.com/app/221100/workshop/
- **BohemiaInteractive Docs**: https://developer.bistudio.com/

---

**Last Updated**: 2025-10-30
