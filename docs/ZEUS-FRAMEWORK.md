# Zeus Framework Implementation

## Overview

Zeus is a comprehensive mission scripting and administrative framework integrated into your DayZ server. It provides modular script support across all major DayZ game lifecycle phases.

## What is Zeus?

Zeus is a modular scripting framework that extends DayZ server capabilities with:

- **Core Engine Scripts** (1_Core): Low-level system initialization
- **Game Module Scripts** (3_Game): Game logic and mechanics
- **World Module Scripts** (4_World): World and environment handling  
- **Mission Module Scripts** (5_Mission): Mission and player interaction systems
- **Logging Utility**: Standardized logging for debug output

## Installation & Setup

### Quick Start

```bash
# Start server with Zeus framework
./cmd/server start base_expansion

# Verify Zeus is loaded
./cmd/verify-zeus

# Check mod bundle
./cmd/mods bundle list
```

### Building Zeus

```bash
# Rebuild Zeus from source
./cmd/mods build Zeus

# Creates: build/@Zeus/addons/Zeus-*.pbo
```

## File Structure

```
pkgs/Zeus/
├── mod.cpp                    # Mod metadata
├── config.cpp                 # Root configuration
└── Zeus/Scripts/
    ├── 1_Core/Zeus/          # Engine core scripts
    │   ├── ZeusCore.c
    │   ├── ZeusCoreInit.c
    │   └── ZeusLog.c          # Logging utility
    ├── 3_Game/Zeus/           # Game module scripts
    │   ├── ZeusGameInit.c
    │   └── ZeusMain.c
    ├── 4_World/Zeus/          # World module scripts
    │   ├── ZeusWorldInit.c
    │   └── ZeusWorldMain.c
    └── 5_Mission/Zeus/        # Mission module scripts
        ├── ZeusMissionInit.c
        ├── ZeusMissionMain.c
        └── init.c
```

## Zeus Modules

### 1_Core (Engine Module)
Runs first during server initialization. Contains:
- `ZeusCore.c` - Core engine startup
- `ZeusCoreInit.c` - Core initialization routine
- `ZeusLog.c` - Logging utility class

### 3_Game (Game Module)
Runs after engine initialization. Contains:
- `ZeusGameInit.c` - Game systems initialization
- `ZeusMain.c` - Main game entry point with modded GameScript class

### 4_World (World Module)
Runs after game initialization. Contains:
- `ZeusWorldInit.c` - World systems initialization
- `ZeusWorldMain.c` - World entry point with modded WorldScript class

### 5_Mission (Mission Module)
Runs when mission loads. Contains:
- `ZeusMissionInit.c` - Mission initialization
- `ZeusMissionMain.c` - Mission entry point with modded MissionScript class
- `init.c` - Mission-specific initialization (stub)

## ZeusLog Utility

The ZeusLog class provides standardized logging:

```c
// Import usage (in your Zeus scripts)
ZeusLog.Info("Information message");
ZeusLog.Warning("Warning message");
ZeusLog.Error("Error message");
ZeusLog.Banner("Section Title");
```

Output format: `[ZEUS] message` or `[ZEUS WARNING]` or `[ZEUS ERROR]`

## Configuration

### Mod Bundle

Zeus is configured as part of the `base_expansion` bundle:

```json
{
  "bundles": {
    "base_expansion": [
      "@cf",
      "@df",
      "@Zeus"
    ]
  }
}
```

Load different bundles with:
```bash
./cmd/server start base_expansion   # Default
./cmd/server start custom_bundle    # Custom bundle
```

### Dependencies

Zeus dependencies (in mod.cpp):
- DZ_Scripts (DayZ core scripts)
- Game module
- World module  
- Mission module

## Verification

Run the verification script to confirm Zeus is installed and loaded:

```bash
./cmd/verify-zeus
```

Output includes:
- ✅ Zeus PBO file check
- ✅ Mod symlink verification
- ✅ Script file count
- ✅ Bundle registration
- ✅ Server status and uptime

## Development

### Adding New Zeus Scripts

1. Create script in appropriate module folder:
   - `pkgs/Zeus/Zeus/Scripts/1_Core/Zeus/YourScript.c`
   - `pkgs/Zeus/Zeus/Scripts/3_Game/Zeus/YourScript.c`
   - etc.

2. Rebuild the mod:
   ```bash
   ./cmd/mods build Zeus
   ```

3. Restart server:
   ```bash
   ./cmd/server stop
   ./cmd/server start base_expansion
   ```

### Script Lifecycle

Scripts are loaded in order by module:
1. Engine core (1_Core) - First
2. Game (3_Game)
3. World (4_World)
4. Mission (5_Mission) - Last

### Modifying Entry Points

Entry points use modded classes:

```c
// In 3_Game/Zeus/ZeusMain.c
modded class GameScript
{
    override void OnInit()
    {
        super.OnInit();
        // Your initialization code
        ZeusLog.Info("Game module loaded");
    }
};
```

## Troubleshooting

### Zeus not loading

1. Check Zeus is in mod bundle:
   ```bash
   ./cmd/mods bundle list
   ```

2. Check mod file exists:
   ```bash
   ls -la mods/@Zeus/
   ```

3. Rebuild mod:
   ```bash
   ./cmd/mods build Zeus
   ```

4. Check server logs:
   ```bash
   tail -100 logs/server.log
   ```

### Script compilation errors

1. Check script syntax in `pkgs/Zeus/Zeus/Scripts/`
2. Rebuild: `./cmd/mods build Zeus`
3. Check build output for errors

## Related Commands

```bash
./cmd/server start base_expansion     # Start with Zeus
./cmd/server stop                     # Stop server
./cmd/server status                  # Check status
./cmd/mods status                    # Show loaded mods
./cmd/mods bundle list               # List bundles
./cmd/verify-zeus                    # Verify Zeus installation
```

## Performance

Zeus is lightweight:
- PBO size: ~5-8 KB
- Minimal performance impact
- Lazy loading of scripts (loaded when modules are needed)

## Support

For issues or questions about Zeus framework:
1. Check this documentation
2. Review script files in `pkgs/Zeus/`
3. Run `./cmd/verify-zeus` for diagnostics
4. Check server logs in `logs/server.log`
