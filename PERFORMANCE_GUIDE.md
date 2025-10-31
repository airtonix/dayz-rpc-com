# DayZ Server Performance Optimization Guide

Guide to optimizing your DayZ server for better performance and stability.

## Server Hardware Requirements

### Minimum Specs (30 players)
- CPU: Intel Xeon E5-2630 or equivalent
- RAM: 16GB
- Storage: 100GB SSD
- Network: 100 Mbps

### Recommended Specs (60 players)
- CPU: Intel Xeon E5-2650 v3 or equivalent
- RAM: 32GB
- Storage: 200GB SSD
- Network: 1 Gbps

### High-End Specs (100+ players)
- CPU: Intel Xeon E5-2680 v3 or Ryzen 9 Threadripper
- RAM: 64GB+
- Storage: 500GB+ NVMe SSD
- Network: 10 Gbps

## Operating System Optimization

### Linux System Tuning

Increase file descriptors:
```bash
# Edit /etc/security/limits.conf
* soft nofile 65535
* hard nofile 65535

# Apply changes
ulimit -n 65535
```

Optimize network stack:
```bash
# Edit /etc/sysctl.conf
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 67108864
net.ipv4.tcp_wmem=4096 65536 67108864
net.core.netdev_max_backlog=5000
net.ipv4.tcp_max_syn_backlog=5000

# Apply settings
sysctl -p
```

### CPU Optimization

```bash
# Disable CPU frequency scaling
echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Check CPU cores
nproc
```

## Server Configuration Optimization

### Network Performance

```
// In serverDZ.cfg

// Reduce network updates for distant players
networkUpdateRate = 12;        // Updates per second (default 12)

// Adjust view distances
objectViewDistance = 2000;     // Objects beyond this not synced
shadowViewDistance = 100;      // Shadow quality

// Loot proximity optimization
lootProxyRange = 100;          // Reduce for better performance
```

### Memory Management

```
// Reduce memory footprint
mapSizeX = 12800;
mapSizeZ = 12800;

// Zombie count (major memory consumer)
// 1 zombie ≈ 5-10 KB memory
maxZombies = 300;              // Adjust based on player count

// AI optimization
maxAIZ = 500;
AILimits = 100;
```

### Rendering Optimization

```
// Grass and vegetation
disableGrass = 0;              // Keep enabled (clients manage rendering)

// Fog (can impact performance)
serverFog = 0.5;

// Shadows
shadowQuality = "low";         // low, medium, high
```

## Script Optimization

### Reduce CPU Usage

```cpp
// Instead of every frame checks:
class BadExample {
    void OnUpdate(float pDt) {
        // This runs every frame - bad!
        CheckAllPlayersHealth();
    }
};

// Use timers instead:
class GoodExample {
    float updateTimer = 0;
    void OnUpdate(float pDt) {
        updateTimer += pDt;
        if (updateTimer > 10)  // Check every 10 seconds
        {
            CheckAllPlayersHealth();
            updateTimer = 0;
        }
    }
};
```

### Optimize Data Structures

```cpp
// Use maps for fast lookups
ref map<string, ref PlayerData> playerCache = new map<string, ref PlayerData>();

// Avoid unnecessary array iterations
// Bad
foreach(PlayerBase player : allPlayers) {
    if (player.GetName() == targetName) {
        // do something
    }
}

// Good
PlayerBase player = playerCache.Get(targetName);
if (player) {
    // do something
}
```

## Mod Optimization

### Load Only Necessary Mods

Remove unused mods from serverDZ.cfg:
```
modDirs[] = {
    "mods/EssentialMod1",
    "mods/EssentialMod2"
    // Don't add decorative-only mods
};
```

### Monitor Mod Performance

Check mod impact:
```bash
# Enable debug logging
./scripts/start-server.sh --debug

# Monitor memory per mod
ps aux | grep dayz
```

## Database Optimization

### SQLite Tuning (if using database)

```sql
-- Optimize queries
PRAGMA synchronous = NORMAL;
PRAGMA cache_size = 10000;
PRAGMA journal_mode = WAL;

-- Create indexes on frequently queried columns
CREATE INDEX idx_player_id ON players(steam_id);
CREATE INDEX idx_position ON objects(x, z);
```

## Monitoring and Diagnostics

### Monitor Server Health

```bash
# Install monitoring tools
apt-get install htop iotop nethogs

# Monitor overall system
htop

# Monitor disk I/O
iotop

# Monitor network
nethogs

# Monitor specific process
ps aux | grep dayz_server
watch -n 1 'ps aux | grep dayz'
```

### Log Analysis

```bash
# Monitor real-time logs
tail -f logs/latest.log

# Search for errors
grep "ERROR" logs/latest.log

# Check performance issues
grep "Performance" logs/latest.log | tail -20

# Count specific events
grep -c "Player connected" logs/latest.log
```

### Performance Metrics

Create monitoring script `scripts/monitor.sh`:
```bash
#!/bin/bash

echo "=== DayZ Server Performance Monitoring ==="
echo ""
echo "CPU Usage:"
ps aux | grep dayz_server | grep -v grep | awk '{print $3"%"}'

echo ""
echo "Memory Usage:"
ps aux | grep dayz_server | grep -v grep | awk '{print $6" KB"}'

echo ""
echo "Network Connections:"
netstat -an | grep ESTABLISHED | wc -l

echo ""
echo "Disk Space:"
df -h | grep -E "^/dev" | awk '{print $5" ("$3"/"$2")"}'

echo ""
echo "Load Average:"
uptime
```

## Bottleneck Identification

### CPU Bottleneck
- Server feels sluggish
- High CPU usage (>80%)
- Solution: Reduce zombie count, optimize scripts

### Memory Bottleneck
- Server crashes with "Out of memory"
- Slow performance after long uptime
- Solution: Reduce player count, check for memory leaks

### Network Bottleneck
- High packet loss
- Players getting kicked for timeout
- Solution: Reduce networkUpdateRate, enable bandwidth limits

### Disk I/O Bottleneck
- Server stalls periodically
- High disk utilization
- Solution: Use SSD, optimize database queries

## Performance Tuning Checklist

- [ ] Optimize system limits (file descriptors, network stack)
- [ ] Tune networkUpdateRate for your player count
- [ ] Set appropriate maxZombies
- [ ] Remove unnecessary mods
- [ ] Enable necessary scripts only
- [ ] Monitor logs for errors
- [ ] Use monitoring tools to identify bottlenecks
- [ ] Implement indexed database queries
- [ ] Cache frequently accessed data
- [ ] Schedule server restarts during low-usage hours
- [ ] Keep server hardware up-to-date
- [ ] Monitor player count vs. resources

## Quick Optimization Settings

For 30 players:
```
networkUpdateRate = 12;
objectViewDistance = 2000;
maxZombies = 150;
lootProxyRange = 100;
```

For 60 players:
```
networkUpdateRate = 10;
objectViewDistance = 1500;
maxZombies = 300;
lootProxyRange = 80;
```

For 100+ players:
```
networkUpdateRate = 8;
objectViewDistance = 1000;
maxZombies = 400;
lootProxyRange = 60;
```

## Recommended Tools

| Tool | Purpose | Installation |
|------|---------|--------------|
| htop | System monitoring | `apt-get install htop` |
| iotop | Disk I/O monitoring | `apt-get install iotop` |
| nethogs | Network monitoring | `apt-get install nethogs` |
| systat | System statistics | `apt-get install sysstat` |

---

**Last Updated**: 2025-10-30
