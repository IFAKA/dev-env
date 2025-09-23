#!/bin/bash

# Restore Universal Development Environment
# Restores from backup created during uninstall

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

# Find backup directory
find_backup() {
    log_info "Looking for backup directories..."
    
    # Look for backup directories
    local backups=($(find ~ -name "dev-env-backup-*" -type d 2>/dev/null | sort -r))
    
    if [ ${#backups[@]} -eq 0 ]; then
        log_error "No backup directories found"
        log_info "Backup directories should be named: dev-env-backup-YYYYMMDD_HHMMSS"
        exit 1
    fi
    
    # Show available backups
    log_info "Available backups:"
    for i in "${!backups[@]}"; do
        echo "  $((i+1)). ${backups[$i]}"
    done
    
    # Let user choose
    read -p "Select backup to restore (1-${#backups[@]}): " choice
    if [[ $choice -ge 1 && $choice -le ${#backups[@]} ]]; then
        BACKUP_DIR="${backups[$((choice-1))]}"
        log_success "Selected backup: $BACKUP_DIR"
    else
        log_error "Invalid selection"
        exit 1
    fi
}

# Restore configurations
restore_configs() {
    log_info "Restoring configurations from backup..."
    
    # Restore shell configs
    if [ -f "$BACKUP_DIR/.zshrc.backup" ]; then
        cp "$BACKUP_DIR/.zshrc.backup" ~/.zshrc
        log_success "Restored .zshrc"
    fi
    
    if [ -f "$BACKUP_DIR/.zsh_aliases.backup" ]; then
        cp "$BACKUP_DIR/.zsh_aliases.backup" ~/.zsh_aliases
        log_success "Restored .zsh_aliases"
    fi
    
    # Restore Git configs
    if [ -f "$BACKUP_DIR/.gitconfig.backup" ]; then
        cp "$BACKUP_DIR/.gitconfig.backup" ~/.gitconfig
        log_success "Restored .gitconfig"
    fi
    
    # Restore Neovim config
    if [ -d "$BACKUP_DIR/nvim.backup" ]; then
        rm -rf ~/.config/nvim
        cp -r "$BACKUP_DIR/nvim.backup" ~/.config/nvim
        log_success "Restored Neovim config"
    fi
    
    # Restore shell history
    if [ -f "$BACKUP_DIR/.zsh_history.backup" ]; then
        cp "$BACKUP_DIR/.zsh_history.backup" ~/.zsh_history
        log_success "Restored .zsh_history"
    fi
    
    if [ -f "$BACKUP_DIR/.bash_history.backup" ]; then
        cp "$BACKUP_DIR/.bash_history.backup" ~/.bash_history
        log_success "Restored .bash_history"
    fi
    
    # Restore SSH configs
    if [ -d "$BACKUP_DIR/ssh.backup" ]; then
        rm -rf ~/.ssh
        cp -r "$BACKUP_DIR/ssh.backup" ~/.ssh
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
        chmod 644 ~/.ssh/id_rsa.pub 2>/dev/null || true
        log_success "Restored SSH configs"
    fi
    
    # Restore custom scripts
    if [ -d "$BACKUP_DIR/bin.backup" ]; then
        rm -rf ~/bin
        cp -r "$BACKUP_DIR/bin.backup" ~/bin
        chmod +x ~/bin/* 2>/dev/null || true
        log_success "Restored custom scripts"
    fi
}

# Validate restore
validate_restore() {
    log_info "Validating restore..."
    
    local errors=0
    
    # Check if configs are restored
    if [ ! -f ~/.zshrc ]; then
        log_error ".zshrc not found"
        ((errors++))
    fi
    
    if [ ! -d ~/.config/nvim ]; then
        log_error "Neovim config not found"
        ((errors++))
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "Restore validation passed"
    else
        log_error "Restore validation failed with $errors errors"
    fi
}

# Show help
show_help() {
    echo "Restore Universal Development Environment"
    echo ""
    echo "Usage: restore [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help"
    echo "  -b, --backup    Specify backup directory"
    echo ""
    echo "Examples:"
    echo "  ./scripts/restore.sh                    # Interactive restore"
    echo "  ./scripts/restore.sh -b ~/backup-dir   # Restore from specific backup"
    echo ""
    echo "This script restores your development environment from a backup"
    echo "created during uninstall."
}

# Main function
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -b|--backup)
                BACKUP_DIR="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Find backup if not specified
    if [ -z "$BACKUP_DIR" ]; then
        find_backup
    fi
    
    # Validate backup directory
    if [ ! -d "$BACKUP_DIR" ]; then
        log_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi
    
    log_info "Restoring from: $BACKUP_DIR"
    
    # Restore configurations
    restore_configs
    
    # Validate restore
    validate_restore
    
    log_success "Restore completed successfully!"
    log_info "Your development environment has been restored"
    log_info "You may need to restart your terminal or run 'source ~/.zshrc'"
}

# Run main function
main "$@"
