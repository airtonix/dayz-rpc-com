# Troubleshooting Guide

## Server Installation Issues

### SteamCMD Not Found
**Error**: `SteamCMD not found`

**Solution**:
```bash
# Install manually
mkdir -p ~/.local/share/steamcmd
cd ~/.local/share/steamcmd
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
chmod +x steamcmd.sh
```

### Steam Authentication Failed
**Error**: `Login timeout` or `Invalid credentials`

**Solutions**:
1. Verify username and password are correct
2. Check internet connectivity
3. Ensure Steam account isn't locked
4. Try with Guard code if 2FA enabled

### Server Files Not Installing
**Error**: `Failed to download server files` or `Failed to validate app`

**Solutions**:
1. Check disk space: `df -h`
2. Verify Steam account has DayZ server license
3. Check network connectivity
4. Try again - downloads can be interrupted

---

## Mod Download Issues

### Mod Download Fails
**Error**: `Failed to download some mods`

**Solutions**:
1. Verify Workshop ID is correct: `./cmd/mods status`
2. Check Steam account has access to mod
3. Ensure internet connectivity
4. Try updating: `./cmd/mods update`

### Missing or Corrupt Mods
**Error**: Server doesn't load mods or crashes

**Solution**: Re-download mods
```bash
./cmd/mods update
./cmd/server stop
./cmd/server start
```

### Mod Signing Key Issues
**Error**: `Bad type 'StringLocaliser'` or signature errors

**Solutions**:
1. Verify `.bikey` files in `keys/` directory:
   ```bash
   ls -la keys/
   ```
2. Check mod folder name matches `serverDZ.cfg`
3. Re-download mods to restore keys:
    ```bash
    ./cmd/mods update
    ```

---

## Server Startup Issues

### Server Won't Start
**Check logs**:
```bash
tail -f logs/server.log
```

**Common causes and solutions**:

#### "DayZServer not found"
```bash
# Verify installation
ls -la server/DayZServer

# Reinstall if missing
./cmd/install
```

#### "Config file not found"
```bash
# Copy config from repo
cp config/serverDZ.cfg server/

# Or reinstall
./cmd/install
```

#### Mod loading errors
```bash
# Verify mods exist
ls -la mods/

# Check folder names match config
cat config/serverDZ.cfg | grep modDirs -A 10

# Verify keys
ls -la keys/
```

#### Out of memory or crash
- Reduce `maxZombies` in `config/serverDZ.cfg`
- Reduce `aiLimits` setting
- Close other applications on server

### Server Starts but Stops Immediately
**Check exit code**:
```bash
# Check last log entry
tail -20 logs/server.log

# Look for specific errors
grep -i error logs/server.log

# Check stderr
tail -20 logs/server.log
```

**Common causes**:
- Invalid configuration syntax
- Conflicting mods
- Insufficient disk space
- Port already in use

### Server Doesn't Create Log Files
**Solution**: Create log directory
```bash
mkdir -p logs/
./cmd/server start
```

---

## Connectivity Issues

### Clients Can't Connect
**Check server status**:
```bash
./cmd/server status
ps aux | grep DayZServer
```

**Check if listening**:
```bash
netstat -tulpn | grep 2302
```

**Check firewall**:
```bash
# Ubuntu with UFW
sudo ufw allow 2302/udp
sudo ufw allow 2303/udp
sudo ufw status
```

**Check ports**:
```bash
# Verify ports in config
grep "port" config/serverDZ.cfg

# Check if ports are open
nc -zv <server-ip> 2302
```

### Server Listed in Browser but Can't Join
**Solutions**:
1. Check firewall rules
2. Ensure mods match between server and client
3. Verify mod signatures (`.bikey` files)
4. Check client has mod subscriptions

### Connection Timeout
**Check server health**:
```bash
# CPU usage
top -p $(cat logs/server.pid)

# Memory
free -h

# Disk space
df -h
```

**Solutions**:
- Reduce server load (mods, AI, players)
- Upgrade server hardware
- Check for runaway processes

---

## Configuration Issues

### Hostname Not Showing Correctly
**Check config**:
```bash
grep "^hostname" config/serverDZ.cfg
```

**Fix**: Edit and restart
```bash
nano config/serverDZ.cfg
./cmd/server stop
./cmd/server start
```

### Wrong Difficulty/Settings
**Verify config is loaded**:
```bash
# Compare configs
diff config/serverDZ.cfg server/serverDZ.cfg
```

**Solution**: Server auto-syncs on startup
```bash
./cmd/server stop
./cmd/server start
```

### Mods Not Loading from Config
**Check mod directories**:
```bash
cat config/serverDZ.cfg | grep modDirs -A 20
```

**Verify folders exist**:
```bash
for dir in $(grep -oP '"mods/\K[^"]+' config/serverDZ.cfg); do
  ls -d "mods/$dir" || echo "MISSING: $dir"
done
```

---

## Performance Issues

### Server Running Slow
**Check system resources**:
```bash
# CPU and memory
top -bn1 | head -20

# Disk I/O
iostat -x 1

# Network
iftop -i eth0
```

**Optimizations**:
1. Reduce `maxZombies` in config
2. Reduce `networkUpdateRate`
3. Increase `objectViewDistance`
4. Disable unused mods

### High CPU Usage
**Check what's running**:
```bash
ps aux | grep -i dayz
htop -p $(cat logs/server.pid)
```

**Solutions**:
- Reduce AI limits: `aiLimits = 50` (lower)
- Reduce zombie count: `maxZombies = 200`
- Check for runaway processes
- Review mod CPU impact

### High Memory Usage
**Check memory**:
```bash
free -h
ps aux --sort=-%mem | grep DayZ
```

**Solutions**:
- Reduce player count if necessary
- Disable memory-heavy mods
- Increase swap space: `fallocate -l 4G /swapfile`

---

## Log Analysis

### Where Are Logs?
```bash
# Main server log
cat logs/server.log

# Recent entries
tail -50 logs/server.log

# Follow in real-time
tail -f logs/server.log

# Search for errors
grep -i error logs/server.log

# Search for warnings
grep -i warn logs/server.log
```

### Common Log Patterns

**Mod loading**:
```
Expansion Mod loading...
[Expansion] Version X.X.X loaded
```

**Errors to watch for**:
```
[ERROR]
[FATAL]
Crash:
Exception:
```

### Enable Debug Mode
For more detailed output:
```bash
./cmd/server start --debug
```

This runs in foreground and shows all output directly.

---

## Getting Help

### Collect Debug Information
```bash
# System info
uname -a
df -h
free -h

# Steam/server info
ls -la server/DayZServer
./cmd/mods status

# Last 100 log lines
tail -100 logs/server.log > debug-logs.txt

# Copy for support
tar -czf debug-bundle.tar.gz logs/ config/ debug-logs.txt
```

### Common Support Resources
- **Server Logs**: `logs/server.log`
- **Configuration**: `config/serverDZ.cfg`
- **Mod Status**: `./cmd/mods status`
- **Running Processes**: `ps aux | grep dayz`

### When Seeking Help
Provide:
1. Error message from logs
2. Steps to reproduce
3. System info (OS, resources)
4. Mods list and versions
5. Recent config changes
