# LaunchAgents

macOS LaunchAgents for auto-starting services on login.

## Included Services

### Ollama (com.ollama.server.plist)

Automatically starts Ollama on login with Chrome extension CORS support.

**Features:**
- ✅ Auto-starts on login
- ✅ Runs in background (no terminal needed)
- ✅ Keeps alive (restarts on crash)
- ✅ CORS enabled (`OLLAMA_ORIGINS="*"`) for Chrome extensions
- ✅ Logs to `/tmp/ollama.log` and `/tmp/ollama.error.log`

**Manual control:**
```bash
# Load service
launchctl load ~/Library/LaunchAgents/com.ollama.server.plist

# Unload service
launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist

# Check status
launchctl list com.ollama.server

# View logs
tail -f /tmp/ollama.log
```

## Installation

The `setup.sh` script handles installation automatically:

```bash
./setup.sh install
```

This will:
1. Symlink plist files to `~/Library/LaunchAgents/`
2. Load the services with `launchctl`
3. Services will start on next login (or immediately if loaded)

## Uninstall

```bash
./setup.sh uninstall
```

This will:
1. Unload all LaunchAgent services
2. Remove symlinks from `~/Library/LaunchAgents/`
3. Leave **zero traces** on the system
