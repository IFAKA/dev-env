# Quick Reference Guide

## 🚀 **Quick Start Commands**

### **Setup & Installation**
```bash
# Initial setup
./setup.sh

# Start development
./scripts/start-dev.sh

# Docker environment
./scripts/docker-manager.sh build
./scripts/docker-manager.sh start-dev
```

### **Daily Workflow**
```bash
# Start workday
./scripts/daily.sh

# SFCC development
./scripts/project-sfcc.sh start
./scripts/sfcc-prophet.sh clean-upload

# Next.js development
./scripts/project-nextjs.sh start

# AI/ML development
./scripts/ai-first.sh
./scripts/python-dev.sh

# Data visualization
./scripts/data-viz.sh
```

## 🔧 **Key Commands**

### **Git Operations**
- `g s` - Git status
- `g a` - Git add
- `g c "msg"` - Git commit
- `g p` - Git push
- `lg` - Lazygit

### **Development**
- `v` - Open Neovim
- `lg` - Lazygit
- `lc` - LeetCode CLI
- `tk` - Task management

### **SFCC Prophet-like**
- `<leader>sfcc-all` - Clean and upload all cartridges
- `<leader>sfcc-clean` - Clean cartridges only
- `<leader>sfcc-upload` - Upload cartridges only
- `<leader>sfcc-status` - Show project status
- `<leader>sfcc-config` - Create dw.json template

### **Docker Environment**
- `docker-manager build` - Build all environments
- `docker-manager start-dev` - Start main development
- `docker-manager start-sfcc` - Start SFCC development
- `docker-manager start-ai` - Start AI/ML development
- `docker-manager start-data` - Start data visualization
- `docker-manager stop` - Stop all environments
- `docker-manager status` - Show environment status

## 📁 **Directory Structure**

```
dev-env/
├── setup.sh                 # Main setup script
├── README.md                 # Main documentation
├── IMPLEMENTATION_PLAN.md    # Implementation plan
├── configs/                  # Configuration files
│   ├── nvim/                # Neovim configuration
│   ├── git/                 # Git configuration
│   ├── ssh/                 # SSH configuration
│   └── zsh/                 # Zsh configuration
├── scripts/                 # Automation scripts
│   ├── daily.sh             # Daily workflow
│   ├── docker-manager.sh    # Docker management
│   ├── sfcc-prophet.sh       # SFCC Prophet-like
│   ├── uninstall.sh         # Safe uninstall
│   └── restore.sh           # Restore from backup
├── docker/                  # Docker environments
│   ├── Dockerfile           # Main development
│   ├── Dockerfile.sfcc      # SFCC development
│   ├── Dockerfile.ai        # AI/ML development
│   └── Dockerfile.data      # Data visualization
└── docs/                    # Documentation
    ├── DOCKER_ENVIRONMENT.md
    ├── SFCC_PROPHET.md
    └── UNINSTALL.md
```

## 🛠️ **Troubleshooting**

### **Common Issues**
1. **Permission denied**: Run `chmod +x scripts/*.sh`
2. **Command not found**: Run `source ~/.zshrc`
3. **Docker not working**: Check Docker installation
4. **Neovim plugins**: Run `:Lazy sync` in Neovim

### **Reset Environment**
```bash
# Safe uninstall
./scripts/uninstall.sh

# Restore from backup
./scripts/restore.sh

# Reinstall
./setup.sh
```

## 📱 **Mobile Development**

### **Android (Termux)**
```bash
# Install Termux
# Install packages
pkg install neovim git nodejs python

# Setup environment
./setup.sh
```

### **iOS (iSH)**
```bash
# Install iSH
# Install packages
apk add neovim git nodejs python3

# Setup environment
./setup.sh
```

## 🔄 **Sync Across Devices**

### **Environment Sync**
```bash
# Sync environment
./scripts/sync.sh

# Update from remote
git pull origin main

# Push changes
git add .
git commit -m "Update environment"
git push origin main
```

### **Code Projects**
```bash
# Each project has its own Git repository
cd ~/code/my-project
git add .
git commit -m "Update project"
git push origin main
```

## 🎯 **Best Practices**

1. **Always use Docker** for heavy processing
2. **Keep environment synced** across devices
3. **Use version control** for all projects
4. **Backup regularly** with restore capability
5. **Test on mobile** devices regularly

## 📞 **Support**

- **Documentation**: Check `docs/` directory
- **Issues**: Check `README.md` troubleshooting
- **Reset**: Use `./scripts/uninstall.sh` and `./scripts/restore.sh`
