# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### 1. Clone and Setup
```bash
git clone <your-repo-url> ~/dev-env
cd ~/dev-env
./setup.sh
```

### 2. Start Development
```bash
# Desktop/Laptop
./scripts/daily.sh

# Mobile (Android/iOS)
./scripts/mobile.sh
```

### 3. Sync Across Devices
```bash
# Setup sync (first time)
./scripts/sync.sh setup

# Sync to remote
./scripts/sync.sh sync

# Pull from remote
./scripts/sync.sh pull
```

## 📱 Mobile Setup

### Android (Termux)
1. Install Termux from F-Droid
2. Run: `pkg install git && git clone <repo> ~/dev-env`
3. Run: `cd ~/dev-env && ./scripts/mobile.sh`

### iOS (iSH)
1. Install iSH from App Store
2. Run: `apk add git && git clone <repo> ~/dev-env`
3. Run: `cd ~/dev-env && ./scripts/mobile.sh`

## 🛠️ Daily Workflow

1. **Start**: `dev start` or `./scripts/daily.sh`
2. **Code**: Neovim with all tools
3. **Commit**: `g a && g c "message" && g p`
4. **Sync**: `./scripts/sync.sh sync`
5. **End**: Exit Neovim (auto-cleanup)

## 🔧 Key Commands

- `dev start` - Start development workflow
- `dev mobile` - Mobile optimizations
- `dev sync` - Sync across devices
- `g s` - Git status
- `g a` - Git add all
- `g c "msg"` - Git commit
- `g p` - Git push
- `lg` - Lazygit
- `lc` - LeetCode CLI
- `tk` - Task management

