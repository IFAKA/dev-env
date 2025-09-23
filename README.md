# Universal Development Environment

A complete, cross-device development setup for **Frontend**, **AI Engineering**, and **Algorithm Trading** that works on any device: Android, iPhone, MacBook, laptop, etc.

## 🎯 Philosophy
- **Local-First Development** - All processing on your device
- **Cross-Device Consistency** - Same experience on any device
- **Zero Manual Setup** - Connect and start coding immediately
- **Keyboard-First Mobile** - External keyboard required for mobile
- **No External Dependencies** - Works offline, syncs when online

## 🔄 Cross-Device Sync
- **GitHub Integration** - Secure, reliable sync via Git
- **Platform Detection** - Automatic platform-specific setup
- **Mobile Support** - Android (Termux) and iOS (iSH) optimized
- **Backup System** - Complete backup before any sync operation
- **Exclude Patterns** - Smart filtering for efficient sync
- **SSH Authentication** - Secure GitHub access across devices

## 📱 Mobile Support
- **Android/Termux** - Full development with external keyboard
- **iOS/iSH** - Limited development with external keyboard
- **Platform Detection** - Automatic mobile platform detection
- **Mobile Aliases** - Keyboard-first mobile shortcuts
- **Storage Permissions** - Automatic Termux storage setup
- **Package Managers** - Platform-specific package management

## 🚀 Quick Start

### Prerequisites
- Terminal access on target device
- Git configured
- Internet connection (for initial setup)

### Installation
```bash
# Clone this repository
git clone <your-repo-url> ~/dev-env
cd ~/dev-env

# Run the setup script
./setup.sh

# Start development
dev start
```

## 📱 Device Support

| Device | Terminal | Package Manager | Development | Status |
|--------|----------|----------------|-------------|--------|
| MacBook/Laptop | Built-in Terminal | Homebrew | ✅ Full | Primary |
| Android | Termux | pkg | ✅ Full | Secondary |
| iOS | iSH | apk | ✅ Limited | Tertiary |

## 🛠️ Tools Included

### Core Development
- **Neovim** with LSP (TypeScript, JavaScript, Python)
  - Custom dashboard (Lazygit-style interface)
  - Auto-shows on startup with no arguments
  - Quick access to all development tools
- **Git** with Lazygit
- **Node.js** with NVM (multiple versions)
- **Python** with pip

### Frontend Development
- **SFCC** - Node.js 14, dwupload CLI, Prophet-like functionality
- **Next.js** - Node.js 18, React, TypeScript
- **Modern Frontend** - Vue, Angular, Svelte
- **Docker Environment** - Insulated development containers

### AI Engineering
- **Jupyter Notebooks** - Data science
- **ML Frameworks** - TensorFlow, PyTorch, scikit-learn
- **AI Tools** - OpenAI, Anthropic, LangChain
- **Data Visualization** - Matplotlib, Seaborn, Plotly
- **Docker Environment** - Insulated AI/ML containers

### Algorithm Trading
- **Financial Data** - yfinance, pandas-datareader
- **Backtesting** - backtrader, zipline
- **Real-time Data** - ccxt, websockets
- **Technical Analysis** - ta-lib, talib
- **Docker Environment** - Insulated data visualization containers

### Productivity
- **Taskwarrior** - Task management
- **HTTPie** - API testing
- **LeetCode CLI** - Coding practice
- **Cursor CLI** - AI assistance

## 🔄 Two Separate Workflows

### 1. Dev Environment (This Repo)
- **Purpose**: Auto-setup development environment
- **Usage**: Clone once, setup once per device
- **Updates**: Only when you update this repo
- **Sync**: Git-based sync of environment configs
- **When you use it**: Initial setup, environment updates

### 2. Code Projects (Separate Repos)
- **Purpose**: Your actual development work
- **Usage**: Clone from GitHub/GitLab, work locally
- **Updates**: Regular development workflow
- **Sync**: Standard Git workflow (push/pull)
- **When you use it**: Daily development work

### Environment Sync (Git-based)
- **What syncs**: Dotfiles, scripts, configurations
- **What doesn't sync**: Code projects (separate repos)
- **How it works**: Git repository for environment configs
- **When it syncs**: On connect, on change, on demand

### Code Projects (Separate)
- **Each project**: Own Git repository on GitHub/GitLab
- **Local development**: All work happens locally
- **Sync method**: Git push/pull to GitHub/GitLab
- **Offline development**: Works without internet

## 📁 Project Structure

```
dev-env/
├── setup.sh              # Main setup script
├── configs/              # All configurations
│   ├── nvim/            # Neovim config
│   ├── zsh/             # Shell configs
│   └── git/             # Git configs
├── scripts/              # Automation scripts
│   ├── daily.sh         # Daily workflow
│   ├── mobile.sh        # Mobile optimizations
│   ├── sync.sh          # Cross-device sync
│   ├── backup-system.sh # Enhanced backup system
│   ├── setup-git-repo.sh # Git repository setup
│   ├── validate-sync.sh  # Sync system validation
│   ├── project-sfcc.sh  # SFCC development
│   ├── project-nextjs.sh # Next.js development
│   ├── install-ai-tools.sh # AI tools
│   ├── uninstall.sh     # Safe uninstall
│   └── restore.sh         # Restore from backup
├── tools/                # Custom tools
├── docs/                 # Documentation
└── .cursor/rules/        # Cursor rules
    └── universal-dev-env.mdc
```

## 🎯 Workflow

### When to Use This Repo
- ✅ **Initial setup** on new device
- ✅ **Environment updates** when repo changes
- ✅ **Configuration changes** you want to sync
- ❌ **Daily development** (use your code projects instead)

### Initial Setup (One-time per device)
```bash
# Clone and setup dev environment
git clone <your-repo-url> ~/dev-env
cd ~/dev-env
./setup.sh

# This installs everything you need for development
# You only need to do this once per device
```

### Daily Development (After setup)
```bash
# Work on your actual projects
cd ~/code/your-project
dev start

# Or use project-specific scripts
./scripts/project-sfcc.sh start
./scripts/project-nextjs.sh start
```

### Working on Projects
```bash
# Clone your projects from GitHub/GitLab
git clone https://github.com/yourusername/your-project.git ~/code/your-project
cd ~/code/your-project

# Start development (uses your dev environment)
dev start
```

### Environment Updates
```bash
# Update dev environment when repo changes
cd ~/dev-env
./scripts/update-env.sh update

# Or manually
git pull
./setup.sh  # Only if new tools/configs added

# Sync environment changes across devices
./scripts/sync.sh sync
```

## 📱 Mobile Setup

### Android (Termux)
```bash
# Install Termux from F-Droid
pkg update && pkg upgrade
pkg install git
git clone <your-repo> ~/dev-env
cd ~/dev-env && ./setup.sh
```

### iOS (iSH)
```bash
# Install iSH from App Store
apk update && apk upgrade
apk add git
git clone <your-repo> ~/dev-env
cd ~/dev-env && ./setup.sh
```

## 🔧 Key Commands

### Development Workflow
- `dev start` - Start development workflow
- `dev mobile` - Mobile optimizations
- `dev sync` - Sync across devices

### Foundation Setup
- `./setup.sh` - Run main setup script
- `./scripts/validate.sh` - Validate environment
- `./scripts/uninstall.sh` - Safe uninstall
- `./scripts/restore.sh` - Restore from backup

### Cross-Device Sync
- `sync setup` - Setup cross-device synchronization
- `sync sync` - Sync to remote repository
- `sync pull` - Pull from remote repository
- `sync backup` - Create backup only
- `sync validate` - Validate sync configuration
- `backup create` - Create comprehensive backup
- `backup list` - List available backups
- `backup restore` - Restore from backup
- `backup info` - Show backup information

### Mobile Support
- `mobile setup` - Setup mobile development environment
- `mobile dev` - Start mobile development workflow
- `mobile sync` - Setup mobile sync
- `mobile validate` - Validate mobile support

### Git Operations
- `g s` - Git status
- `g a` - Git add all
- `g c "msg"` - Git commit
- `g p` - Git push
- `lg` - Lazygit

### Neovim Dashboard
- **Auto-start**: Shows automatically when opening Neovim with no arguments
- **Manual access**: `<leader>d` to show dashboard anytime
- **Quick actions**: Press any key shown to execute action
- **Sections**:
  - 🚀 Quick Start (files, grep, buffers, explorer)
  - 📁 File Operations (new, open, recent, save)
  - 🔧 Development (terminal, Lazygit, AI, LeetCode)
  - 🛒 SFCC Development (clean, upload, status)
  - 🤖 AI & Data Science (Jupyter, Python REPL, plots)
  - ⚙️ System (help, quit, update, health)
- **Testing**: `./scripts/test-dashboard.sh` to verify functionality

### SFCC Prophet-like (Neovim)
- `<leader>sfcc-all` - Clean and upload all cartridges
- `<leader>sfcc-clean` - Clean cartridges only
- `<leader>sfcc-upload` - Upload cartridges only
- `<leader>sfcc-status` - Show project status
- `<leader>sfcc-config` - Create dw.json template

### Docker Environment
- `docker-manager build` - Build all Docker environments
- `docker-manager start-dev` - Start main development environment
- `docker-manager start-sfcc` - Start SFCC development environment
- `docker-manager start-ai` - Start AI/ML development environment
- `docker-manager start-data` - Start data visualization environment
- `docker-manager stop` - Stop all environments
- `docker-manager status` - Show environment status

### Testing
- `./scripts/test-dashboard.sh` - Test Neovim dashboard functionality
- `./scripts/test-edge-cases.sh` - Test edge cases and error handling
- `./scripts/validate-sync.sh` - Validate cross-device sync setup
- `./scripts/validate-mobile.sh` - Validate mobile support setup

### Productivity
- `lc` - LeetCode CLI
- `tk` - Task management

## 🔄 Cross-Device Sync Setup

### Initial Setup
```bash
# Setup Git repository for sync
./scripts/setup-git-repo.sh

# Setup cross-device synchronization
./scripts/sync.sh setup

# Create initial backup
./scripts/backup-system.sh create
```

### Daily Sync
```bash
# Sync to remote (push changes)
./scripts/sync.sh sync

# Sync from remote (pull changes)
./scripts/sync.sh pull

# Validate sync system
./scripts/validate-sync.sh
```

### Backup Management
```bash
# Create comprehensive backup
./scripts/backup-system.sh create

# List available backups
./scripts/backup-system.sh list

# Restore from backup
./scripts/backup-system.sh restore backup-name

# Show backup information
./scripts/backup-system.sh info backup-name
```

## 📱 Mobile Setup

### Android/Termux Setup
```bash
# Setup Android/Termux environment
./configs/mobile/android-termux.sh setup

# Start mobile development
./configs/mobile/android-termux.sh dev

# Setup mobile sync
./configs/mobile/android-termux.sh sync
```

### iOS/iSH Setup
```bash
# Setup iOS/iSH environment
./configs/mobile/ios-ish.sh setup

# Start mobile development
./configs/mobile/ios-ish.sh dev

# Setup mobile sync
./configs/mobile/ios-ish.sh sync
```

### Mobile Validation
```bash
# Validate mobile support
./scripts/validate-mobile.sh
```

## 🚨 Safe Uninstall

```bash
# Uninstall without breaking changes
./scripts/uninstall.sh
```

This will:
- **Backup everything** - All configs, history, SSH keys, custom scripts
- **Remove packages** - Optional removal of all installed tools
- **Remove Node.js** - Optional removal of NVM and Node.js
- **Restore originals** - Restore your original configurations
- **Clean directories** - Remove all dev-env related files
- **Validate uninstall** - Ensure everything is properly removed

### Restore from Backup

```bash
# Restore from backup (interactive)
./scripts/restore.sh

# Restore from specific backup
./scripts/restore.sh -b ~/dev-env-backup-20241201_143022
```

This will:
- **Find backups** - List all available backups
- **Restore configs** - Restore all configurations
- **Restore history** - Restore shell history
- **Restore SSH** - Restore SSH keys and configs
- **Validate restore** - Ensure everything is restored correctly

## 🆘 Troubleshooting

### Common Issues
- **Permission denied**: Run `chmod +x scripts/*.sh`
- **Command not found**: Check PATH in ~/.zshrc
- **Git not configured**: Run `git config --global user.name "Your Name"`

### Mobile Issues
- **Termux not working**: Install from F-Droid, not Play Store
- **iSH limitations**: Some features may not work in iSH
- **Touch not working**: Check Neovim mobile config

### Sync Issues
- **SSH key not working**: Add public key to GitHub
- **Remote not found**: Check git remote URL
- **Permission denied**: Check SSH key permissions

### Solutions

#### Reset Environment
```bash
# Backup current state
./scripts/sync.sh backup

# Reset to clean state
rm -rf ~/.config/nvim
rm -rf ~/.zshrc
rm -rf ~/.zsh_aliases

# Reinstall
./setup.sh
```

#### Mobile Reset
```bash
# Android/Termux
pkg update && pkg upgrade
rm -rf ~/.config/nvim
./scripts/mobile.sh

# iOS/iSH
apk update && apk upgrade
rm -rf ~/.config/nvim
./scripts/mobile.sh
```

#### Sync Reset
```bash
# Reset sync
rm -rf ~/dev-sync
./scripts/sync.sh setup
```

### Validation
```bash
# Validate environment
./scripts/validate.sh

# Check sync status
./scripts/sync.sh validate
```

## 📞 Support

- **Documentation**: See `docs/` directory
- **Issues**: Check `IMPLEMENTATION_PLAN.md` for detailed setup
- **Validation**: Run `./scripts/validate.sh` for health checks

