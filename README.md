# DayZ Expansion Server

A streamlined DayZ server setup with the Expansion mod suite, including AI, base building, markets, and quests.

## Quick Start

### Prerequisites
- Linux server (Ubuntu 20.04+)
- ~100GB disk space
- Steam account with DayZ server license
- SteamCMD (installed automatically)

### Installation

1. **Install the server**
   ```bash
   ./cmd/install
   ```
   This will:
   - Check system requirements
   - Install SteamCMD
   - Download DayZ server files (~50GB)
   - Create directory structure

2. **Download mods**
   ```bash
   ./cmd/mods install
   ```
   This will:
   - Install the mods listed in the `./config/mods.cfg`

3. **Start the server**
   ```bash
   ./cmd/server start
   ```

4. **Stop the server**
   ```bash
   ./cmd/server stop
   ```

## Configuration

**Server Settings** → `config/serverDZ.cfg`
- Hostname, port, difficulty, player count
- Mod directories (auto-configured)

**Mods** → `config/mods.cfg`
- Add/remove mods by Steam Workshop ID
- Run `./cmd/mods install` after editing
- More Info: 
  - `./cmd/mods help`
  - read [./docs/mods.md](./docs/mods.md)

**Items & Spawns** → `config/types.xml`
- Item definitions and spawn rates

## Management

| Task | Command |
|------|---------|
| Server status | `./cmd/server status` |
| View logs | `./cmd/server logs-tail` |
| Update server | `./cmd/server update` |
| List mods | `./cmd/mods list` |
| Add mod | `./cmd/mods add <id> <@name>` |
| Remove mod | `./cmd/mods remove <@name>` |
| Update mods | `./cmd/mods update` |
| Debug mode | `./cmd/server start --debug` |
| Restart | `./cmd/server restart` |
| Help | `./cmd/<tool> help` |

## Directory Structure

```
.
├── cmd/                   # Command tools
│   ├── install           # Install server and dependencies
│   ├── mods              # Manage mods
│   └── server            # Control server
├── config/               # Configuration files
│   ├── serverDZ.cfg      # Main server config
│   ├── types.xml         # Items configuration
│   ├── mods.cfg          # Mod list
│   └── mission.xml       # Mission config
├── mods/                 # Downloaded mods
├── keys/                 # Mod signing keys
├── logs/                 # Server logs
├── server/               # DayZ server installation
└── docs/                 # Detailed documentation
```

## Next Steps

- **Customize server**: Edit `config/serverDZ.cfg`
- **Add/remove mods**: Edit `config/mods.cfg`, run `./cmd/mods install`
- **View detailed docs**: See `docs/` directory
- **See all commands**: `./cmd/<tool> help`

## Troubleshooting

**Server won't start**
- Check: `./cmd/server logs-tail`
- Verify mods are installed: `./cmd/mods list`
- Ensure Steam credentials are valid

**Clients can't connect**
- Check firewall (default ports 2302-2303)
- Verify hostname in config matches server address
- Ensure all mods are subscribed on client

**Mods not loading**
- Confirm mods folder names match `serverDZ.cfg`
- Check `.bikey` files are in `keys/` directory
- Review logs for mod errors: `./cmd/server logs-tail`

## Documentation

- [Command Tools Guide](docs/commands.md) - Detailed tool usage
- [Installation Guide](docs/installation.md) - Step-by-step setup
- [Configuration Reference](docs/config.md) - All config options
- [Mod Management](docs/mods.md) - Adding/removing mods
- [Modding Guide](docs/modding.md) - Creating custom mods
- [Troubleshooting](docs/troubleshooting.md) - Common issues
- [Performance Tuning](docs/performance.md) - Optimization tips
- [Gist Review](docs/gist-review.md) - Comparison with original gist

## Resources

- [DayZ Wiki](https://dayz.gamepedia.com/)
- [Expansion Mod Wiki](https://github.com/salutesh/DayZ-Expansion-Scripts/wiki)
- [BohemiaInteractive Docs](https://developer.bistudio.com/)

---

**Last Updated**: 2025-10-31
**DayZ Expansion Version**: Latest
