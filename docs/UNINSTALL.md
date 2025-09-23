# Safe Uninstall Guide

This guide explains how to safely uninstall the Universal Development Environment without breaking your system.

## 🎯 What Gets Removed

### Optional Package Removal
- **Core Tools**: Neovim, Lazygit, fzf, ripgrep, bat, exa
- **Development Tools**: Taskwarrior, HTTPie, Timetrap, LeetCode CLI
- **Node.js Packages**: dwupload, TypeScript, ESLint, Prettier
- **Python Packages**: Jupyter, ML frameworks, data visualization tools

### Configuration Removal
- **Shell Configs**: .zshrc, .zsh_aliases modifications
- **Git Configs**: .gitconfig modifications
- **Neovim Config**: Complete Neovim configuration
- **SSH Configs**: SSH keys and configuration
- **Custom Scripts**: Any custom scripts in ~/bin

### Directory Cleanup
- **dev-env directory**: Complete removal
- **Backup directories**: dev-backup, dev-sync
- **Project directories**: python-projects, ai-projects, trading-projects
- **Temporary files**: .dev-env-*, .sync-exclude

## 🚀 Uninstall Process

### 1. Interactive Uninstall
```bash
# Start uninstall process
./scripts/uninstall.sh

# Follow the prompts:
# - Confirm uninstall (y/N)
# - Remove packages (y/N)
# - Remove Node.js (y/N)
```

### 2. What Happens During Uninstall

#### Step 1: Backup Creation
- Creates timestamped backup directory
- Backs up all existing configurations
- Backs up shell history and SSH keys
- Backs up custom scripts

#### Step 2: Configuration Removal
- Removes environment-specific configurations
- Removes symlinks and aliases
- Cleans up shell configuration

#### Step 3: Package Removal (Optional)
- Removes installed packages via package manager
- Removes Node.js packages via npm
- Supports multiple package managers (brew, apt, yum, pacman, pkg, apk)

#### Step 4: Node.js Removal (Optional)
- Removes NVM directory
- Removes Node.js from shell configuration
- Cleans up Node.js related files

#### Step 5: Directory Cleanup
- Removes dev-env directory
- Removes backup and sync directories
- Removes project directories
- Removes temporary files

#### Step 6: Validation
- Validates uninstall was successful
- Checks for remaining files
- Reports any issues

## 🔄 Restore Process

### 1. Find Available Backups
```bash
# List all available backups
find ~ -name "dev-env-backup-*" -type d

# Example output:
# /Users/username/dev-env-backup-20241201_143022
# /Users/username/dev-env-backup-20241201_150045
```

### 2. Interactive Restore
```bash
# Start restore process
./scripts/restore.sh

# Follow the prompts:
# - Select backup to restore
# - Confirm restore
```

### 3. Direct Restore
```bash
# Restore from specific backup
./scripts/restore.sh -b ~/dev-env-backup-20241201_143022
```

### 4. What Gets Restored
- **Shell Configs**: .zshrc, .zsh_aliases
- **Git Configs**: .gitconfig
- **Neovim Config**: Complete Neovim configuration
- **Shell History**: .zsh_history, .bash_history
- **SSH Configs**: SSH keys and configuration
- **Custom Scripts**: Custom scripts in ~/bin

## 🛡️ Safety Features

### Backup Protection
- **Timestamped backups** - Never overwrites existing backups
- **Complete backup** - Backs up everything, not just configs
- **Validation** - Ensures backup was created successfully

### Rollback Capability
- **Easy restore** - Simple command to restore everything
- **Multiple backups** - Keep multiple backup versions
- **Selective restore** - Choose which backup to restore

### Validation
- **Uninstall validation** - Ensures uninstall was successful
- **Restore validation** - Ensures restore was successful
- **Error reporting** - Clear error messages and solutions

## 🔧 Manual Cleanup

If the automated uninstall doesn't work, you can manually clean up:

### Remove Directories
```bash
# Remove main directory
rm -rf ~/dev-env

# Remove backup directories
rm -rf ~/dev-backup
rm -rf ~/dev-sync

# Remove project directories
rm -rf ~/code/python-projects
rm -rf ~/code/ai-projects
rm -rf ~/code/trading-projects
```

### Remove Configurations
```bash
# Remove shell modifications
sed -i.bak '/# dev-env specific/,/# end dev-env/d' ~/.zshrc
rm -f ~/.zshrc.bak

# Remove Neovim config
rm -rf ~/.config/nvim

# Remove custom scripts
rm -rf ~/bin
```

### Remove Packages
```bash
# macOS
brew uninstall neovim lazygit fzf ripgrep bat exa task httpie timetrap leetcode-cli

# Ubuntu/Debian
sudo apt remove -y neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli

# Android/Termux
pkg remove neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli

# iOS/iSH
apk del neovim lazygit fzf ripgrep bat exa task httpie timetrap leetcode-cli
```

## 🆘 Troubleshooting

### Uninstall Issues
- **Permission denied**: Run `chmod +x scripts/uninstall.sh`
- **Backup failed**: Check disk space and permissions
- **Package removal failed**: Try manual removal
- **Config restoration failed**: Check backup directory

### Restore Issues
- **No backups found**: Check backup directory names
- **Restore failed**: Check backup directory permissions
- **Config conflicts**: Remove conflicting files first
- **SSH key issues**: Check SSH key permissions

### Recovery
- **Lost backups**: Check ~/dev-env-backup-* directories
- **Corrupted configs**: Restore from backup
- **System issues**: Restore original configurations
- **Package conflicts**: Remove conflicting packages

## 📋 Checklist

### Before Uninstall
- [ ] Backup important data
- [ ] Note any custom configurations
- [ ] Check available disk space
- [ ] Ensure you have admin privileges

### After Uninstall
- [ ] Verify original configs are restored
- [ ] Check that packages are removed (if requested)
- [ ] Verify directories are cleaned up
- [ ] Test that system still works

### After Restore
- [ ] Verify configurations are restored
- [ ] Check that tools are working
- [ ] Verify SSH keys are restored
- [ ] Test development environment

## 🎯 Best Practices

### Regular Backups
- **Create backups** before major changes
- **Keep multiple backups** for different versions
- **Test restore process** to ensure it works
- **Clean up old backups** periodically

### Safe Uninstall
- **Read prompts carefully** before confirming
- **Choose package removal** only if you're sure
- **Keep backups** for at least a few days
- **Test system** after uninstall

### Easy Restore
- **Use interactive restore** for simplicity
- **Check backup dates** before restoring
- **Verify restore** after completion
- **Test environment** after restore

This ensures you can safely uninstall and restore your development environment without breaking your system.
