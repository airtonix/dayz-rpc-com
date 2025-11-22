# Implementation Guide: Client/Server Mod Bundle Support

## Overview
This implementation adds support for distinguishing between server-only mods and client mods in the mod bundle system. Server mods are loaded via the `--serverMod` parameter and don't need to be installed on clients, while client mods are installed via Steam Workshop subscriptions.

## Changes Made

### 1. Configuration Structure (config/mods.json)
Bundles now have explicit `server` and `client` arrays:

```json
{
  "bundles": {
    "base_expansion": {
      "server": ["@Zeus"],
      "client": ["@cf", "@df", "@de-core", "@de", "@de-ai"]
    }
  }
}
```

### 2. CLI Changes (cmd/mods)

#### Bundle Creation
**Old**: `./cmd/mods bundle create NAME mod1 mod2...` (ambiguous type)
**New**: 
```bash
./cmd/mods bundle create NAME --server mod1 mod2...
./cmd/mods bundle create NAME --client mod1 mod2...
```

#### Bundle Addition
**Old**: `./cmd/mods bundle add NAME mod1 mod2...` (added to mixed array)
**New**:
```bash
./cmd/mods bundle add NAME --server mod1 mod2...
./cmd/mods bundle add NAME --client mod1 mod2...
```

#### Bundle Removal
**Old**: `./cmd/mods bundle remove NAME mod1 mod2...` (would fail on structure change)
**New**: `./cmd/mods bundle remove NAME mod1 mod2...` (auto-detects which section)
- Removes from both `server` and `client` arrays
- No flag needed since type is auto-detected

#### Bundle Listing
**Old**: Listed all mods in single line
**New**: Shows clear separation:
```
base_expansion:
  Server: @Zeus
  Client: @cf, @df, @de-core, @de, @de-ai
```

### 3. Server Startup Changes (cmd/server)

#### Parameter Change
**Old**: `-mod=@mod1;@mod2;@mod3` (mixed)
**New**: `--serverMod=@mod1;@mod2;@mod3` (server-only)

#### Loading Logic
```bash
# OLD: Loaded all mods from bundle
local mod_list=$(jq '.bundles[$bundle] | map("mods/" + .) | join(";")')

# NEW: Loads only server mods
local mod_list=$(jq '.bundles[$bundle].server // [] | map("mods/" + .) | join(";")')
```

#### Startup Output
```bash
# Before
[*] Loading 6 mod(s) from bundle 'base_expansion'

# After
[*] Loading 1 server mod(s) from bundle 'base_expansion'
(client mods are handled via Steam Workshop)
```

### 4. Documentation Updates

#### docs/mods.md
Added new section "Server vs Client Mods" with:
- Explanation of server-only vs client mods
- Comparison table of differences
- Bundle structure examples
- CLI command examples

#### docs/config.md
Added new section "Mod Startup Parameters" with:
- Explanation of `--serverMod` parameter
- Bundle-based mod loading documentation
- Link to docs/mods.md for more details

## Usage Examples

### Creating a Bundle with Mixed Mods
```bash
# Create bundle starting with server mod
./cmd/mods bundle create pvp_server --server @Zeus

# Add client mods
./cmd/mods bundle add pvp_server --client @cf @df @de
```

### Viewing Bundle Composition
```bash
./cmd/mods bundle list

# Output:
# pvp_server:
#   Server: @Zeus
#   Client: @cf, @df, @de
```

### Modifying Bundles
```bash
# Add more server mods
./cmd/mods bundle add pvp_server --server @custom-admin

# Remove a client mod (auto-detects)
./cmd/mods bundle remove pvp_server @de
```

### Starting Server with Bundle
The bundle is used automatically in cmd/server:
```bash
./cmd/server start pvp_server

# Internally uses:
# --serverMod=@Zeus;@custom-admin
# Client mods (@cf, @df) are documented but not loaded by server
```

## Implementation Details

### Bundle Functions Updated
1. **create_bundle()**: 
   - Parses `--server` or `--client` flag
   - Creates bundle with appropriate structure
   - Validates mods exist in global mods list

2. **add_to_bundle()**: 
   - Requires `--server` or `--client` flag
   - Uses jq to add mods to correct array
   - Applies `unique` filter to prevent duplicates

3. **remove_from_bundle()**: 
   - No flag needed (auto-detects)
   - Removes from both arrays in case mod exists in both
   - Uses jq array subtraction operator

4. **list_bundles()**: 
   - Shows separate Server/Client sections
   - Displays "[none]" if array is empty
   - More readable output

### Server Startup Updated
- Changed parameter from `-mod` to `--serverMod`
- Loads only `.bundles[$bundle].server` array
- Falls back to empty string if no server mods
- Clear messaging about client mods

## Backward Compatibility Notes
⚠️ **Breaking Change**: Bundles created before this change will have a different structure. Old format:
```json
"bundle_name": ["@mod1", "@mod2"]
```

New format:
```json
"bundle_name": {"server": [], "client": ["@mod1", "@mod2"]}
```

**Migration**: Bundles must be recreated using new CLI syntax.

## Testing Performed
✅ create_bundle with --server flag
✅ create_bundle with --client flag  
✅ add_to_bundle with --server flag
✅ add_to_bundle with --client flag
✅ remove_from_bundle (auto-detect)
✅ list_bundles (shows server/client)
✅ Duplicate prevention with unique filter
✅ Validation of mods in global list
✅ Server startup parameter generation
