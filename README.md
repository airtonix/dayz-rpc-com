# DayZ Server Modding Setup

A comprehensive setup guide and configuration repository for running and modding a DayZ server.

## Quick Start

### Prerequisites
- DayZ Server files (available through SteamCMD)
- Linux server (Ubuntu 20.04+ recommended)
- ~100GB disk space for server files and mods
- A Steam account with DayZ server license

### Installation Steps

1. **Clone this repository**
   ```bash
   git clone <repo-url>
   cd dayz-server-modding
   ```

2. **Run the installation script**
   ```bash
   chmod +x scripts/install-server.sh
   ./scripts/install-server.sh
   ```

3. **Configure your server**
   - Edit `config/serverDZ.cfg` with your server settings
   - Edit `config/types.xml` for item/spawn configuration
   - Add mods to `mods/` directory

4. **Start the server**
   ```bash
   ./scripts/start-server.sh
   ```

## Directory Structure

```
.
├── README.md                 # This file
├── MODDING_GUIDE.md         # Detailed modding guide
├── config/                  # Server configuration files
│   ├── serverDZ.cfg         # Main server config
│   ├── types.xml            # Item types configuration
│   ├── mission.xml          # Mission/scenario config
│   └── templates/           # Config templates
├── mods/                    # Custom mods
│   ├── YOUR_MOD_NAME/
│   │   ├── mod.cpp
│   │   ├── meta.cpp
│   │   └── ...
│   └── .gitignore
├── scripts/                 # Helper scripts
│   ├── install-server.sh    # Initial server setup
│   ├── start-server.sh      # Start server
│   ├── stop-server.sh       # Stop server
│   ├── update-mods.sh       # Update installed mods
│   └── manage-mods.sh       # Manage mod dependencies
├── tools/                   # Development tools
│   ├── workbench-tools/     # Workbench integration
│   └── build-helpers.sh     # Build utility functions
├── docker-compose.yml       # Docker development environment
└── .gitignore

```

## Key Features

- **Automated Installation**: Scripts to download and setup DayZ server
- **Mod Management**: Tools for managing mod dependencies and versions
- **Configuration Templates**: Pre-configured templates for common setups
- **Docker Support**: Development environment via Docker
- **Documentation**: Comprehensive guides for modding

## Common Tasks

### Adding a Mod

1. Place mod folder in `mods/` directory
2. Add mod signature files to `keys/` directory (for client verification)
3. Update `serverDZ.cfg` with mod name in `modDirs` setting
4. Restart server

### Creating a Custom Mod

See [MODDING_GUIDE.md](./MODDING_GUIDE.md) for detailed instructions.

### Updating Server

```bash
./scripts/update-server.sh
```

### Managing Mods

```bash
./scripts/manage-mods.sh --list          # List installed mods
./scripts/manage-mods.sh --add mod_name  # Add a mod
./scripts/manage-mods.sh --remove mod_name  # Remove a mod
```

## Documentation

- **[MODDING_GUIDE.md](./MODDING_GUIDE.md)** - Complete guide to creating and modifying DayZ mods
- **[CONFIG_GUIDE.md](./CONFIG_GUIDE.md)** - Configuration reference
- **[PERFORMANCE_GUIDE.md](./PERFORMANCE_GUIDE.md)** - Server optimization tips

## Common Issues

### Server won't start
- Check logs: `cat logs/latest.log`
- Verify mod signatures are present
- Ensure mods are in correct format

### Clients can't connect to server
- Check firewall rules (default port 2302-2303)
- Verify server is listening: `netstat -tulpn | grep dayz`
- Ensure mod signatures match between server and client

### Mod conflicts
- Use `./scripts/manage-mods.sh --check-conflicts` to identify issues
- Review mod load order in `serverDZ.cfg`

## Resources

- **Official DayZ Wiki**: https://dayz.gamepedia.com/
- **DayZ Community Forums**: https://forums.dayz.com/
- **Modding Tools**: https://developer.bistudio.com/

## License

This repository is provided as-is for DayZ server administration purposes.

## Support

For issues related to this setup:
1. Check the troubleshooting section above
2. Review logs in `logs/` directory
3. Consult the documentation files

---

**Last Updated**: 2025-10-30
**DayZ Version**: Compatible with DayZ 1.25+
