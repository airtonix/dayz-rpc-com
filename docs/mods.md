# Mod Management Guide

## Current Mod Setup

The default configuration includes 5 essential mods:

| Mod | ID | Folder | Purpose |
|-----|----|----|---------|
| Community Framework | 1559212036 | @cf | Core framework (required) |
| Dabs Framework | 2545327648 | @df | Additional framework support |
| DayZ Expansion | 2116151222 | @de | Main expansion features |
| DayZ Expansion Core | 2291785308 | @de-core | Core expansion functionality |
| DayZ Expansion AI | 2792982069 | @de-ai | AI system for NPCs |

## Server vs Client Mods

DayZ distinguishes between server-only mods and client mods, which affects how they're configured:

### Server Mods (ServerMods)
- Run **only** on the DayZ server
- Loaded via `--serverMod=@modname` parameter at server startup
- Don't need to be installed on clients
- Useful for admin tools, custom server logic, performance optimizations
- **Example**: `@Zeus` (admin framework)
- **Enable**: `./cmd/mods enable 0 @Zeus --server`

### Client Mods
- Installed by players from Steam Workshop
- Create gameplay features visible to clients
- Not required in server startup command
- Must be subscribed to by players to connect (if server has `verifyMods = 1`)
- **Example**: `@cf`, `@df`, `@de` (frameworks and expansions)
- **Enable**: `./cmd/mods enable 1559212036 @cf --client`

### Why the Distinction?

| Aspect | Server Mods | Client Mods |
|--------|-------------|-------------|
| Installation | Server only | Players' Steam Workshop |
| Startup Parameter | `--serverMod=@mod1;@mod2` | Not in startup command |
| Player Requirement | No subscription needed | Must subscribe to join |
| Use Case | Admin tools, server logic | Gameplay features, content |

### Bundles with Mixed Mods

Bundles organize mods by their role. A bundle separates server and client mods for clarity:

```json
{
  "bundles": {
    "base_expansion": {
      "server": [
        "@Zeus"
      ],
      "client": [
        "@cf",
        "@df",
        "@de-core",
        "@de",
        "@de-ai"
      ]
    }
  }
}
```

**Server Behavior**:
- When starting with bundle `base_expansion`, server loads: `--serverMod=@Zeus`
- Clients must subscribe to: @cf, @df, @de-core, @de, @de-ai

**Bundle Commands**:
```bash
# Add a server-only mod
./cmd/mods bundle add base_expansion --server @admin-tools

# Add a client mod
./cmd/mods bundle add base_expansion --client @cosmetics

# Remove a mod (type doesn't matter)
./cmd/mods bundle remove base_expansion @cosmetics

# View bundle composition
./cmd/mods bundle list
```

## Finding Mods

### Steam Workshop
1. Visit: https://steamcommunity.com/app/221100/workshop/
2. Search for mod name
3. Click mod page
4. Extract ID from URL: `...?id=XXXXXXXXXX`

### DayZ Launcher
1. Open DayZ Launcher
2. Go to "Mods" tab
3. Right-click mod → "Copy Link"
4. Extract ID from URL

## Mod Configuration File Structure

### mods.json Format

The `config/mods.json` file defines all available mods and their properties:

```json
{
  "server": "./server/DayZServer",
  "mods": [
    {
      "id": 1559212036,
      "name": "@cf",
      "title": "Community Framework",
      "path": "mods/@cf"
    }
  ],
  "bundles": { ... }
}
```

**Field Descriptions**:

| Field | Purpose | Example |
|-------|---------|---------|
| `server` | Path to server binary (used for relative path computation) | `./server/DayZServer` |
| `id` | Steam Workshop ID (0 for local dev mods) | `1559212036` |
| `name` | Mod identifier with @ prefix | `@cf` |
| `title` | Human-readable mod name | `Community Framework` |
| `path` | Relative path to mod directory (repo-relative) | `mods/@cf` |
| `development` | Flag for local development mods | `true` |

### The `path` Field

The `path` field is critical for server startup. It defines where the mod is located relative to the repository root:

- **Purpose**: Allows flexible mod placement and dynamic path computation
- **Format**: Repository-relative path (e.g., `mods/@modname`, `custom-mods/@modname`)
- **Automatic**: When using `./cmd/mods register`, the path is populated automatically
- **Custom Paths**: You can set custom paths for mods in different locations:

```json
{
  "mods": [
    {
      "id": 2116151222,
      "name": "@de",
      "path": "mods/@de"
    },
    {
      "id": 999999999,
      "name": "@custom-location",
      "path": "custom-mods/@custom-location"
    }
  ]
}
```

When the server starts, it computes relative paths from the server binary location. For example:
- Mod path: `mods/@de` (repo-relative)
- Server binary: `./server/DayZServer`
- Result: `../mods/@de` (server-relative, in serverDZ.cfg)

## Adding a Mod

### Method 1: Using cmd/mods
```bash
./cmd/mods enable 2116151222 @de
./cmd/mods install
```

### Method 2: Edit config/mods.json Directly
```json
{
  "mods": [
    {
      "id": 1559212036,
      "name": "@cf",
      "title": "Community Framework",
      "path": "mods/@cf"
    },
    {
      "id": 2116151222,
      "name": "@de",
      "title": "DayZ Expansion",
      "path": "mods/@de"
    },
    {
      "id": 999999999,
      "name": "@new-mod",
      "title": "New Mod",
      "path": "mods/@new-mod"
    }
  ]
}
```

Then install:
```bash
./cmd/mods install
```

## Removing a Mod

### Method 1: Using cmd/mods
```bash
./cmd/mods disable @de
```

### Method 2: Edit config/mods.json
Remove the mod object from the array, then reinstall to clean up:
```bash
./cmd/mods install
```

## Installation Details

When you run `./cmd/mods install`, the script:

1. **Downloads** from Steam Workshop to `server/steamapps/workshop/content/221100/`
2. **Copies** to `mods/@folder-name/`
3. **Extracts keys** - All `.bikey` files → `keys/`
4. **Normalizes names** - Converts filenames to lowercase for compatibility

## Folder Structure After Installation

```
mods/
├── @cf/                    # Community Framework
│   ├── addons/
│   ├── keys/
│   │   └── cf.bikey
│   ├── mod.cpp
│   └── ...
├── @de/                    # DayZ Expansion
│   ├── addons/
│   ├── keys/
│   │   └── dayz-expansion.bikey
│   └── ...
└── @de-ai/
    └── ...

keys/
├── cf.bikey
├── dayz-expansion.bikey
└── ...
```

## Mod Load Order

The order matters! The file `config/serverDZ.cfg` controls load order:

```
modDirs[] = {
    "mods/@cf",           // Must be first
    "mods/@df",           // Must be second
    "mods/@de-core",      // Core before features
    "mods/@de",           // Main expansion
    "mods/@de-ai"         // Feature mods
};
```

**Critical**: CF and DF must load before other mods!

## Troubleshooting

### Mod Won't Download
- Check Steam Workshop ID is correct
- Verify Steam credentials are valid
- Ensure Steam account has mod access
- Check network connectivity

### Mod Not Loading
- Verify folder name in `mods/` matches `serverDZ.cfg`
- Check `.bikey` files are in `keys/` directory
- Ensure `verifyMods = 1` in `serverDZ.cfg`
- Check server logs: `tail logs/server.log`

### "Bad type" Errors
- Missing or incorrect `.bikey` files
- CF or DF not loading (must be first)
- Folder name typo in config

### Mod Conflicts
- Review load order in `serverDZ.cfg`
- Check for duplicate mod functionality
- Review server logs for specific errors

## Common Mod Operations

### List Installed Mods
```bash
./cmd/mods status
```

Output:
```
========================================
Configured Mods
========================================

1. @cf (ID: 1559212036)
   Status: [INSTALLED] (450MB)
2. @de (ID: 2116151222)
   Status: [INSTALLED] (2.3GB)

Total: 5 mod(s)
```

### Update All Mods
```bash
./cmd/mods update
```

This re-downloads from Steam Workshop, useful for:
- Getting latest patches
- Fixing corrupted mod files
- Resetting mod configuration

### Check Mod Sizes
```bash
du -sh mods/*
```

Example output:
```
450M    mods/@cf
1.2G    mods/@de
680M    mods/@de-core
1.5G    mods/@de-ai
350M    mods/@df
```

## Server Restart Required

After adding/removing mods:
```bash
./cmd/server stop
./cmd/server start
```

The server auto-syncs `config/serverDZ.cfg` on startup.

## Expanding Beyond Minimal Setup

The 5-mod setup is minimal. Other useful Expansion mods:

```bash
# Base building
./cmd/mods enable 2792982513 @de-basebuilding

# Markets and trading
./cmd/mods enable 2572328470 @de-market

# Quests
./cmd/mods enable 2828486817 @de-quests

# Vehicles
./cmd/mods enable 2291785437 @de-vehicles

# Animations
./cmd/mods enable 2793893086 @de-animations
```

Then install and restart:
```bash
./cmd/mods install
./cmd/server stop
./cmd/server start
```

## Backing Up Mods

```bash
# Backup mod folder
tar -czf backups/mods-backup.tar.gz mods/ keys/

# Restore
tar -xzf backups/mods-backup.tar.gz
```
