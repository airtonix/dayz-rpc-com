# DayZ Server Configuration Guide

Comprehensive reference for configuring a DayZ server.

## serverDZ.cfg - Main Configuration

### Server Identity

```
hostname = "My DayZ Server";
port = 2302;
bindAddress = "0.0.0.0";
steamPort = 2303;
```

### Game Settings

```
// Server difficulty
difficulty = "hard";  // easy, medium, hard, hardcore

// Player management
maxPlayers = 60;
maxPlayers_Steam = 60;

// Admin settings
allowFilePatching = 0;  // 0=disabled, 1=enabled
persistent = 1;         // World persistence

// Networking
instanceId = 1;
serverRebootTimer = 480;  // Minutes between restarts
```

### Mod Configuration

```
modDirs[] = {
    "mods/MyMod1",
    "mods/MyMod2",
    "mods/MyMod3"
};

// Enable mod verification
verifyMods = 1;
```

### Gameplay Parameters

```
// Time settings
serverTime = "10:00";
serverTimeAcceleration = 2;      // How fast time passes
serverNightTimeAcceleration = 1;
serverFog = 0.1;

// PvP settings
disableBaseDamage = 0;
disableContainers = 0;

// Loot
lootProxyRange = 60;             // Loot visibility range
```

### Admin & Whitelist

```
// Admin UIDs (Steam ID)
admins[] = {
    "76561198000000000"
};

// Whitelist
whitelistFile = "whitelist.txt";
persistent = 1;
```

## types.xml - Item Configuration

Location: `config/types.xml`

### Basic Item Definition

```xml
<type name="ItemName">
    <category name="weapon" />
    <category name="melee" />
    <value name="inventorySlots">4</value>
    <value name="weight">1000</value>
    <value name="absorbency">0</value>
</type>
```

### Item Properties

```xml
<type name="Rifle">
    <!-- Identification -->
    <name>Military Rifle</name>
    <category name="weapon" />
    <category name="firearm" />
    
    <!-- Physical Properties -->
    <value name="inventorySlots">8</value>
    <value name="weight">3500</value>
    <value name="absorbency">0</value>
    
    <!-- Gameplay Properties -->
    <value name="hungerBonus">0</value>
    <value name="healthBonus">0</value>
    <value name="bloodBonus">0</value>
    <value name="shockBonus">0</value>
    
    <!-- Repair -->
    <value name="repairableWithKits">Firearm</value>
    <value name="repairCosts">
        <repair_kit_type name="ItemCleaningKit">2</repair_kit_type>
        <repair_kit_type name="ItemOilcan">1</repair_kit_type>
    </value>
    
    <!-- Damage -->
    <value name="damage">50</value>
    <value name="range">400</value>
    
    <!-- Attachments -->
    <attachments>
        <attachment name="Optic_attachment" />
        <attachment name="Magazine_attachment" />
    </attachments>
</type>
```

### Spawn Configuration

```xml
<type name="SpawnPoint">
    <cargo name="default">
        <item name="Zombie_Hunter" chance="1.0" />
        <item name="ItemKnife" chance="0.3" />
        <item name="ItemDressing" chance="0.5" />
    </cargo>
</type>
```

## mission.xml - Mission Configuration

Location: `config/mission.xml` or set via Workbench

```xml
<mission version="1">
    <name>DayZ_Default</name>
    
    <playerSpawnTypes>
        <spawnType name="default" />
        <spawnType name="coast" x="2000" z="2000" />
        <spawnType name="inland" x="5000" z="5000" />
    </playerSpawnTypes>
    
    <!-- Loot spawns -->
    <lootProxies>
        <proxy name="Default_Loot" />
    </lootProxies>
</mission>
```

## Server Performance Tuning

### Reduce Lag

```
// Reduce update frequency for distant objects
objectViewDistance = 1000;
shadowViewDistance = 150;

// Reduce AI computation
aiLimits = 100;

// Network optimization
networkUpdateRate = 12;  // Updates per second
```

### Monitor Resources

```bash
# Check server memory usage
ps aux | grep dayz

# Monitor network traffic
iftop -i eth0

# Check disk space
df -h
```

## Whitelist Configuration

Create `whitelist.txt`:

```
# DayZ Server Whitelist
# Format: SteamID

76561198000000000
76561198000000001
76561198000000002
```

## Blacklist Configuration

Create `blacklist.txt`:

```
# Banned Players
# Format: SteamID or IP

76561198999999999
192.168.1.100
```

## Combat Parameters

```xml
<zombieParams>
    <!-- Zombie count -->
    <maxZombies>500</maxZombies>
    <zombieSpawnRadius>200</zombieSpawnRadius>
    
    <!-- Zombie behavior -->
    <zombieAggression>high</zombieAggression>
    <zombieFatigue>normal</zombieFatigue>
</zombieParams>
```

## Environmental Settings

```xml
<environment>
    <!-- Weather -->
    <weatherType>random</weatherType>
    <rainChance>0.3</rainChance>
    <fogType>realistic</fogType>
    
    <!-- Time -->
    <dayLength>60</dayLength>    <!-- minutes -->
    <nightLength>20</nightLength>
    
    <!-- Water -->
    <waterLevel>standard</waterLevel>
</environment>
```

## Event Configuration

```xml
<events>
    <!-- Scheduled server messages -->
    <message time="08:00" text="Welcome to our server!" />
    <message time="20:00" text="Server maintenance in 1 hour" />
    
    <!-- Dynamic events -->
    <meteorShower chance="0.1" />
    <animalMigration enabled="1" />
</events>
```

## Security Settings

```
// Prevent admin abuse
adminCanKickPlayers = 1;
adminCanBanPlayers = 1;
adminCanEditVehicles = 0;  // Prevent spawning items

// Prevent cheating
VAC = 1;                    // Enable VAC
battleEyeEnabled = 1;       // Enable BattlEye

// Log all admin actions
adminLogFile = "logs/admin.log";
```

## Common Configurations

### PvP Server
```
disableBaseDamage = 0;
disableContainers = 0;
difficulty = "hardcore";
serverTime = "random";
```

### Roleplay Server
```
disableBaseDamage = 0;
difficulty = "hard";
serverTime = "10:00";
verifyMods = 1;
```

### Survival Server
```
disableBaseDamage = 1;
difficulty = "hardcore";
serverNightTimeAcceleration = 0.5;
maxPlayers = 30;
```

## Troubleshooting Configuration Issues

| Issue | Solution |
|-------|----------|
| Server won't start | Check syntax in config files, validate XML |
| Players can't join | Check firewall, verify port forwarding |
| Mods not loading | Verify mod paths in modDirs[], check logs |
| High latency | Reduce networkUpdateRate, increase culling distances |
| Crashes | Check server logs, verify sufficient RAM |

---

**Last Updated**: 2025-10-30
