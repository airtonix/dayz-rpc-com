# DayZ Modding Guide

Complete guide for creating, developing, and deploying mods for DayZ servers.

## Prerequisites

- DayZ Tools (Workbench) installed
- Visual Studio Community (for C++ development, optional)
- Oxygen IDE (for scripting)
- Basic understanding of DayZ modding concepts

## Mod Structure

```
MyCustomMod/
├── mod.cpp                  # Mod configuration
├── meta.cpp                 # Metadata
├── config/
│   ├── CfgPatches.xml      # Patch configuration
│   ├── types.xml           # Item definitions
│   └── ...
├── scripts/
│   ├── 4_World/            # Game world scripts
│   ├── 3_Game/             # Game logic scripts
│   ├── 5_Mission/          # Mission scripts
│   └── ...
├── data/
│   ├── scripts/
│   ├── models/
│   └── textures/
└── keys/
    └── MyCustomMod.bikey   # Signing key
```

## Creating Your First Mod

### Step 1: Set Up Workbench Project

1. Open DayZ Workbench
2. Create new project in `mods/` directory
3. Name your mod (e.g., `MyCustomMod`)

### Step 2: Configure mod.cpp

```cpp
name = "My Custom Mod";
dir = "MyCustomMod";
type = "mod";
dependencies[] = {"DayZ"};
class defs {
    class imageSets {
        files[] = {};
    };
    class XmlDefs {
        files[] = {};
    };
};
```

### Step 3: Configure meta.cpp

```cpp
class Meta {
    version = "1.0.0";
    oceanAnimationCodeVersion = 1;
    class Game {
        type = "DayZ";
        minVersion = "1.25";
        maxVersion = "*";
        steam = 1;
    };
};
```

### Step 4: Create Configuration Files

#### CfgPatches.xml (config/CfgPatches.xml)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Patch version="1.000">
    <Class name="cfgPatches">
        <Class name="MyCustomMod">
            <Value class="array" name="units" />
            <Value class="array" name="weapons" />
            <Value class="array" name="requiredAddons">
                <Value>DayZ_Core</Value>
            </Value>
            <Value class="bool" name="requiredVersion">0</Value>
        </Class>
    </Class>
</Patch>
```

## Common Modding Tasks

### Adding Custom Items

Create in `config/types.xml`:

```xml
<type name="CustomWeapon">
    <category name="weapon" />
    <category name="melee" />
    <value name="inventorySlots">4</value>
    <value name="weight">1200</value>
    <value name="absorbency">0</value>
    <value name="repairableWithKits">Firearm, Melee</value>
    <value name="repairCosts">
        <repair_kit_type name="Cleaner_ItemCleaningKit">1</repair_kit_type>
    </value>
</type>
```

### Modifying Item Spawns

Edit `config/types.xml` to adjust spawn rates:

```xml
<type name="Zombies">
    <cargo name="default">
        <item name="Zombie_Hunter" chance="1.0" />
        <item name="Zombie_Worker" chance="0.5" />
    </cargo>
</type>
```

### Creating Custom Behaviors

Create script in `scripts/4_World/`:

```cpp
class MyCustomBehavior extends PlayerBase {
    void MyCustomAction() {
        // Your behavior code here
    }
};
```

### Adding Models and Textures

1. Place 3D models in `data/models/`
2. Place textures in `data/textures/`
3. Reference in config files:
   ```xml
   <value name="model">MyCustomMod\data\models\mymodel.p3d</value>
   ```

## Scripting Basics

### Event Handlers

```cpp
override void OnInit() {
    super.OnInit();
    // Initialization code
}

override void OnUpdate(float pDt) {
    super.OnUpdate(pDt);
    // Called every frame
}
```

### Working with Items

```cpp
ItemBase item = GetGame().CreateObject("MyCustomItem", position);
if (item) {
    item.SetQuantity(50);
}
```

### Network Synchronization

```cpp
override void OnVariablesSynchronized() {
    super.OnVariablesSynchronized();
    // Handle networked variable changes
}
```

## Building and Packaging

### Compile in Workbench

1. File → Publish (or Project → Build)
2. Set output directory to `mods/MyCustomMod`
3. Select "Pack" to create .zip

### Sign Your Mod

Signing keys are automatically extracted when mods are installed. Ensure your mod is properly configured in `mod.cpp` before publishing.

## Testing Your Mod

### Local Testing

1. Copy mod to `mods/` directory
2. Start server with `./cmd/server start`
3. Connect as admin and test functionality

### Common Test Scenarios

- Item spawning and pickup
- Player interactions
- Network synchronization
- Server-client communication

## Debugging

### Enable Debug Mode

Add to `serverDZ.cfg`:
```
debugLevel = 2;
```

### Check Logs

```bash
tail -f logs/latest.log | grep "MyCustomMod"
```

### Common Errors

| Error | Solution |
|-------|----------|
| `No entry '...'` | Config file not properly formatted or referenced |
| `Undefined variable` | Variable not declared or in wrong scope |
| `Network sync failed` | Check variable replication settings |
| `Model not found` | Verify path in config and model file exists |

## Best Practices

1. **Version Control**: Use semantic versioning (1.0.0)
2. **Documentation**: Document all custom features
3. **Testing**: Test on both server and client
4. **Performance**: Minimize script overhead and object counts
5. **Compatibility**: Check dependencies on other mods
6. **Security**: Validate all player inputs server-side
7. **Code Style**: Follow DayZ naming conventions

## Mod Dependencies

Declare dependencies in `mod.cpp`:

```cpp
dependencies[] = {"DayZ", "OtherMod"};
```

## Publishing to Steam

1. Create mod folder with required files
2. Build and package in Workbench
3. Create Steam Workshop item
4. Upload .zip to Steam
5. Wait for approval

## Resources

- **Official Documentation**: https://developer.bistudio.com/
- **Workbench Wiki**: https://community.bistudio.com/wiki/Category:DayZ_Modding
- **Community Forums**: https://forums.dayz.com/forum/98-dayz-modding/

---

**Last Updated**: 2025-10-30
