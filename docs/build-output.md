# DayZ Mod Build Output Structure

## Overview

When you build a mod with `./cmd/mods build mymod`, the build process creates a structured output with versioning, metadata, and ready-to-use server artifacts.

## Directory Structure

```
build/                             ← Build artifacts (ephemeral)
├── @MyMod/
│   ├── addons/
│   │   └── MyMod-1.0.0.pbo       ← Versioned PBO file
│   ├── keys/
│   │   ├── MyMod.bikey           ← Public signature key
│   │   └── MyMod.biprivatekey    ← Private signature key
│   ├── mod.cpp                   ← Mod metadata (name, version, author)
│   └── version.txt               ← Version metadata JSON

mods/                              ← Server-ready mods
└── @MyMod → ../build/@MyMod      ← Symlink (direct use with server)

pkgs/                              ← Source code
└── @MyMod/
    ├── config.cpp
    ├── Scripts/
    ├── Data/
    ├── version                    ← Optional: version file
    ├── package.json               ← Optional: version in package
    └── mod.cpp                    ← Optional: custom mod metadata
```

## Version Calculation

Version is determined in this priority order:

1. **Git Tag/Hash** (if in git repo)
   ```bash
   git describe --tags --always
   # Returns: v1.0.0 or abc123def456
   ```

2. **Version File** (`pkgs/@ModName/version`)
   ```
   1.0.0
   ```

3. **package.json** (`pkgs/@ModName/package.json`)
   ```json
   { "version": "1.0.0" }
   ```

4. **Fallback** (no version found)
   ```
   0.0.0-local
   ```

## Output Files

### PBO File (Versioned)
- **Filename**: `MyMod-1.0.0.pbo`
- **Location**: `build/@MyMod/addons/`
- **Contains**: Compiled mod (rapified configs, binarized assets)

### version.txt (Metadata)
- **Location**: `build/@MyMod/`
- **Format**: JSON
- **Content**:
  ```json
  {
    "version": "1.0.0",
    "commit": "abc123def456",
    "buildtime": "2024-11-01T15:03:30Z"
  }
  ```
- **Use**: Server can query mod version without unpacking PBO

### mod.cpp (Mod Manifest)
- **Location**: `build/@MyMod/`
- **Source**: Either copied from `pkgs/@MyMod/mod.cpp` or auto-generated
- **Format**: DayZ mod manifest format
- **Content**:
  ```
  name = "My Mod";
  version = "1.0.0";
  author = "Author Name";
  description = "Mod description";
  ```

### Keys (Optional)
- **Location**: `build/@MyMod/keys/`
- **Files**: 
  - `ModName.bikey` (public signature key)
  - `ModName.biprivatekey` (private signature key, keep secret!)
- **Use**: Signature verification on secure servers

## Using Built Mods

### For Local Server Testing
Built mods are immediately usable via the symlink:

```bash
# Server configuration
-mod=@MyMod

# Actual location (via symlink):
# mods/@MyMod → ../build/@MyMod/
```

### For Distribution
Copy the entire `build/@ModName/` directory:
- PBO is versioned and ready to deploy
- Keys are included if available
- mod.cpp describes the mod
- version.txt provides metadata

### For CI/CD
Archive the build output:
```bash
tar -czf MyMod-1.0.0.tar.gz build/@MyMod/
```

## Build Console Output

```
[*] Building mod: MyMod
[*] Version: 1.0.0
[*] Source: /path/to/pkgs/@MyMod
[*] Output: /path/to/build/@MyMod

[*] Creating PBO from source...
[*] Generating version metadata...
[*] Ensuring mod.cpp...
[*] Copying signing keys...
[*] Creating symlink in mods directory...

[+] Build complete!

Module Information:
  Name:       MyMod
  Version:    1.0.0
  Commit:     abc123def456
  Build Time: 2024-11-01 15:03:30

Output Files:
-rw-r--r-- 1 user group 1.2M Nov  1 15:03 MyMod-1.0.0.pbo

Ready for server:
  mods/@MyMod/
```

## Cleaning Builds

To remove all build artifacts:

```bash
# Remove just one mod's build
rm -rf build/@MyMod

# Remove all builds
rm -rf build/

# Note: mods/@* symlinks will be broken after this
```

## Versioning Best Practices

1. **Use Git Tags** for official releases
   ```bash
   git tag v1.0.0
   ./cmd/mods build mymod
   # Creates: MyMod-1.0.0.pbo
   ```

2. **Use version File** for manual control
   ```bash
   echo "1.0.0-beta.1" > pkgs/@MyMod/version
   ./cmd/mods build mymod
   # Creates: MyMod-1.0.0-beta.1.pbo
   ```

3. **Fallback Handling** for development
   ```bash
   # No version? Uses 0.0.0-local
   ./cmd/mods build mymod
   # Creates: MyMod-0.0.0-local.pbo
   ```

## Server Integration

### Reading Version at Runtime
Servers can read `version.txt` to report mod information:

```bash
# Example server startup output
Loading @MyMod (v1.0.0-abc123) [2024-11-01T15:03:30Z]
```

### Checking Mod Compatibility
The version.txt JSON allows automated checking:
- Version matching for compatibility
- Build time validation
- Commit tracking for debugging

## Symlink Details

The `mods/@ModName` symlink:
- Points to: `../build/@ModName/` (relative path)
- Created automatically during build
- Updated if mod is rebuilt
- Allows server config to use `-mod=@ModName`

**Note**: On Windows without admin, symlink creation may fail with a warning. In this case:
- Use Windows junction: `mklink /J mods\@ModName build\@ModName`
- Or copy build output directly to mods/
