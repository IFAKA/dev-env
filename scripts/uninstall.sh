#!/bin/bash

# Uninstall Universal Development Environment
# Safely removes the environment without breaking existing configurations

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup existing configurations
backup_existing() {
    log_info "Creating backup of existing configurations..."
    
    BACKUP_DIR="$HOME/dev-env-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing configs if they exist
    [ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/.zshrc.backup"
    [ -f ~/.zsh_aliases ] && cp ~/.zsh_aliases "$BACKUP_DIR/.zsh_aliases.backup"
    [ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_DIR/.gitconfig.backup"
    [ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim.backup"
    
    # Backup shell history
    [ -f ~/.zsh_history ] && cp ~/.zsh_history "$BACKUP_DIR/.zsh_history.backup"
    [ -f ~/.bash_history ] && cp ~/.bash_history "$BACKUP_DIR/.bash_history.backup"
    
    # Backup SSH configs
    [ -d ~/.ssh ] && cp -r ~/.ssh "$BACKUP_DIR/ssh.backup"
    
    # Backup any custom scripts
    [ -d ~/bin ] && cp -r ~/bin "$BACKUP_DIR/bin.backup"
    
    log_success "Backup created at: $BACKUP_DIR"
}

# Restore original configurations
restore_original() {
    log_info "Restoring original configurations..."
    
    # Restore original shell configs
    if [ -f ~/.zshrc.backup ]; then
        mv ~/.zshrc.backup ~/.zshrc
        log_success "Restored original .zshrc"
    fi
    
    if [ -f ~/.zsh_aliases.backup ]; then
        mv ~/.zsh_aliases.backup ~/.zsh_aliases
        log_success "Restored original .zsh_aliases"
    fi
    
    if [ -f ~/.gitconfig.backup ]; then
        mv ~/.gitconfig.backup ~/.gitconfig
        log_success "Restored original .gitconfig"
    fi
    
    if [ -d ~/.config/nvim.backup ]; then
        rm -rf ~/.config/nvim
        mv ~/.config/nvim.backup ~/.config/nvim
        log_success "Restored original Neovim config"
    fi
}

# Remove environment-specific configurations
remove_environment_configs() {
    log_info "Removing environment-specific configurations..."
    
    # Remove symlinks and environment-specific files
    rm -f ~/bin/daily
    rm -f ~/bin/mobile
    rm -f ~/bin/sync
    rm -f ~/bin/validate
    
    # Remove environment-specific aliases from shell config
    if [ -f ~/.zshrc ]; then
        # Remove lines that contain dev-env specific content
        sed -i.bak '/# dev-env specific/,/# end dev-env/d' ~/.zshrc
        rm -f ~/.zshrc.bak
    fi
    
    log_success "Removed environment-specific configurations"
}

# Remove installed packages (optional)
remove_packages() {
    log_info "Removing installed packages (optional)..."
    
    read -p "Do you want to remove installed packages? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove packages based on platform
        if command -v brew &> /dev/null; then
            # macOS
            log_info "Removing packages via Homebrew..."
            brew uninstall neovim lazygit fzf ripgrep bat exa task httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        elif command -v pkg &> /dev/null; then
            # Android/Termux
            log_info "Removing packages via pkg..."
            pkg remove neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        elif command -v apk &> /dev/null; then
            # iOS/iSH
            log_info "Removing packages via apk..."
            apk del neovim lazygit fzf ripgrep bat exa task httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        elif command -v apt &> /dev/null; then
            # Ubuntu/Debian
            log_info "Removing packages via apt..."
            sudo apt remove -y neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            log_info "Removing packages via yum..."
            sudo yum remove -y neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            log_info "Removing packages via pacman..."
            sudo pacman -R --noconfirm neovim lazygit fzf ripgrep bat exa taskwarrior httpie timetrap leetcode-cli || true
            # Remove Node.js packages
            npm uninstall -g dwupload typescript typescript-language-server eslint prettier leetcode-cli || true
        else
            log_warning "Unknown package manager, skipping package removal"
        fi
        log_success "Packages removed"
    else
        log_info "Skipping package removal"
    fi
}

# Clean up directories
cleanup_directories() {
    log_info "Cleaning up directories..."
    
    # Remove dev-env directory
    if [ -d ~/dev-env ]; then
        rm -rf ~/dev-env
        log_success "Removed dev-env directory"
    fi
    
    # Remove backup directories
    rm -rf ~/dev-backup
    rm -rf ~/dev-sync
    
    # Remove any dev-env related directories
    rm -rf ~/code/python-projects
    rm -rf ~/code/ai-projects
    rm -rf ~/code/trading-projects
    
    # Remove any dev-env related files
    rm -f ~/.dev-env-*
    rm -f ~/.sync-exclude
    
    log_success "Cleaned up directories"
}

# Remove NVM and Node.js (optional)
remove_nodejs() {
    log_info "Removing Node.js and NVM (optional)..."
    
    read -p "Do you want to remove Node.js and NVM? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove NVM
        if [ -d ~/.nvm ]; then
            rm -rf ~/.nvm
            log_success "Removed NVM"
        fi
        
        # Remove Node.js from shell config
        if [ -f ~/.zshrc ]; then
            sed -i.bak '/# NVM/,/# End NVM/d' ~/.zshrc
            rm -f ~/.zshrc.bak
        fi
        
        if [ -f ~/.bashrc ]; then
            sed -i.bak '/# NVM/,/# End NVM/d' ~/.bashrc
            rm -f ~/.bashrc.bak
        fi
        
        log_success "Node.js and NVM removed"
    else
        log_info "Skipping Node.js removal"
    fi
}

# Validate uninstall
validate_uninstall() {
    log_info "Validating uninstall..."
    
    local errors=0
    
    # Check if dev-env directory is gone
    if [ -d ~/dev-env ]; then
        log_error "dev-env directory still exists"
        ((errors++))
    fi
    
    # Check if configs are restored
    if [ ! -f ~/.zshrc ]; then
        log_warning ".zshrc not found (may have been removed)"
    fi
    
    # Check if packages are removed (if requested)
    if command -v neovim &> /dev/null; then
        log_warning "Neovim still installed (may have been kept)"
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "Uninstall validation passed"
    else
        log_error "Uninstall validation failed with $errors errors"
    fi
}

# Main uninstall function
main() {
    log_info "Starting uninstall process..."
    
    # Confirm uninstall
    read -p "Are you sure you want to uninstall the development environment? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled"
        exit 0
    fi
    
    # Create backup
    backup_existing
    
    # Remove environment configs
    remove_environment_configs
    
    # Restore original configs
    restore_original
    
    # Remove packages (optional)
    remove_packages
    
    # Remove Node.js (optional)
    remove_nodejs
    
    # Clean up directories
    cleanup_directories
    
    # Validate uninstall
    validate_uninstall
    
    log_success "Uninstall completed successfully!"
    log_info "Your original configurations have been restored"
    log_info "Backup created at: $BACKUP_DIR"
    log_info "You can restore from backup if needed"
}

# Run main function
main "$@"
