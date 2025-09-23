#!/bin/bash

# Enhanced Backup System
# Provides comprehensive backup and restore functionality for cross-device sync

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

# Configuration
BACKUP_DIR="$HOME/dev-backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="dev-env-backup-$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
EXCLUDE_FILE="$HOME/.sync-exclude"

# Create backup directory
create_backup_dir() {
    log_info "Creating backup directory..."
    mkdir -p "$BACKUP_PATH"
    log_success "Backup directory created: $BACKUP_PATH"
}

# Backup development environment
backup_dev_env() {
    log_info "Backing up development environment..."
    
    # Backup dev-env directory
    if [ -d "$HOME/dev-env" ]; then
        cp -r "$HOME/dev-env" "$BACKUP_PATH/"
        log_success "dev-env directory backed up"
    fi
    
    # Backup configuration files
    mkdir -p "$BACKUP_PATH/configs"
    
    # Backup shell configurations
    [ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_PATH/configs/"
    [ -f ~/.zsh_aliases ] && cp ~/.zsh_aliases "$BACKUP_PATH/configs/"
    [ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_PATH/configs/"
    [ -f ~/.bash_aliases ] && cp ~/.bash_aliases "$BACKUP_PATH/configs/"
    
    # Backup Git configuration
    [ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_PATH/configs/"
    
    # Backup SSH keys
    if [ -d ~/.ssh ]; then
        cp -r ~/.ssh "$BACKUP_PATH/configs/"
        log_success "SSH keys backed up"
    fi
    
    # Backup Neovim configuration
    if [ -d ~/.config/nvim ]; then
        cp -r ~/.config/nvim "$BACKUP_PATH/configs/"
        log_success "Neovim configuration backed up"
    fi
    
    # Backup code projects
    if [ -d ~/code ]; then
        cp -r ~/code "$BACKUP_PATH/"
        log_success "Code projects backed up"
    fi
    
    # Backup shell history
    [ -f ~/.zsh_history ] && cp ~/.zsh_history "$BACKUP_PATH/configs/"
    [ -f ~/.bash_history ] && cp ~/.bash_history "$BACKUP_PATH/configs/"
    
    log_success "Development environment backed up to: $BACKUP_PATH"
}

# Backup system information
backup_system_info() {
    log_info "Backing up system information..."
    
    # Create system info file
    cat > "$BACKUP_PATH/system-info.txt" << EOF
# System Information Backup
# Created: $(date)
# Platform: $(uname -a)
# User: $(whoami)
# Home: $HOME
# Shell: $SHELL

# Installed packages
$(which brew >/dev/null 2>&1 && brew list --formula || echo "Homebrew not available")
$(which npm >/dev/null 2>&1 && npm list -g --depth=0 || echo "npm not available")
$(which pip3 >/dev/null 2>&1 && pip3 list || echo "pip3 not available")

# Environment variables
$(env | grep -E '^(PATH|HOME|USER|SHELL|EDITOR|VISUAL)')

# Git configuration
$(git config --list --global || echo "Git not configured")
EOF
    
    log_success "System information backed up"
}

# Create backup manifest
create_backup_manifest() {
    log_info "Creating backup manifest..."
    
    cat > "$BACKUP_PATH/manifest.txt" << EOF
# Backup Manifest
# Created: $(date)
# Backup Name: $BACKUP_NAME
# Platform: $(uname -s)
# User: $(whoami)

## Contents:
$(find "$BACKUP_PATH" -type f | sort)

## Directories:
$(find "$BACKUP_PATH" -type d | sort)

## File sizes:
$(du -sh "$BACKUP_PATH"/* 2>/dev/null || echo "No files found")
EOF
    
    log_success "Backup manifest created"
}

# Compress backup
compress_backup() {
    log_info "Compressing backup..."
    
    cd "$BACKUP_DIR"
    tar -czf "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"
    
    # Remove uncompressed backup
    rm -rf "$BACKUP_NAME"
    
    log_success "Backup compressed: $BACKUP_DIR/$BACKUP_NAME.tar.gz"
}

# List available backups
list_backups() {
    log_info "Available backups:"
    
    if [ -d "$BACKUP_DIR" ]; then
        ls -la "$BACKUP_DIR" | grep -E "(backup|dev-env-backup)" || echo "No backups found"
    else
        echo "No backup directory found"
    fi
}

# Restore from backup
restore_backup() {
    local backup_name="$1"
    
    if [ -z "$backup_name" ]; then
        log_error "Please specify backup name"
        list_backups
        exit 1
    fi
    
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [ ! -d "$backup_path" ] && [ ! -f "$backup_path.tar.gz" ]; then
        log_error "Backup not found: $backup_name"
        list_backups
        exit 1
    fi
    
    log_info "Restoring from backup: $backup_name"
    
    # Extract if compressed
    if [ -f "$backup_path.tar.gz" ]; then
        log_info "Extracting compressed backup..."
        cd "$BACKUP_DIR"
        tar -xzf "$backup_name.tar.gz"
        backup_path="$BACKUP_DIR/$backup_name"
    fi
    
    # Restore dev-env directory
    if [ -d "$backup_path/dev-env" ]; then
        log_info "Restoring dev-env directory..."
        rm -rf "$HOME/dev-env"
        cp -r "$backup_path/dev-env" "$HOME/"
        log_success "dev-env directory restored"
    fi
    
    # Restore configuration files
    if [ -d "$backup_path/configs" ]; then
        log_info "Restoring configuration files..."
        
        # Restore shell configurations
        [ -f "$backup_path/configs/.zshrc" ] && cp "$backup_path/configs/.zshrc" ~/
        [ -f "$backup_path/configs/.zsh_aliases" ] && cp "$backup_path/configs/.zsh_aliases" ~/
        [ -f "$backup_path/configs/.bashrc" ] && cp "$backup_path/configs/.bashrc" ~/
        [ -f "$backup_path/configs/.bash_aliases" ] && cp "$backup_path/configs/.bash_aliases" ~/
        
        # Restore Git configuration
        [ -f "$backup_path/configs/.gitconfig" ] && cp "$backup_path/configs/.gitconfig" ~/
        
        # Restore SSH keys
        if [ -d "$backup_path/configs/.ssh" ]; then
            cp -r "$backup_path/configs/.ssh" ~/
            chmod 700 ~/.ssh
            chmod 600 ~/.ssh/id_rsa 2>/dev/null || true
            chmod 644 ~/.ssh/id_rsa.pub 2>/dev/null || true
        fi
        
        # Restore Neovim configuration
        if [ -d "$backup_path/configs/nvim" ]; then
            mkdir -p ~/.config
            cp -r "$backup_path/configs/nvim" ~/.config/
        fi
        
        # Restore shell history
        [ -f "$backup_path/configs/.zsh_history" ] && cp "$backup_path/configs/.zsh_history" ~/
        [ -f "$backup_path/configs/.bash_history" ] && cp "$backup_path/configs/.bash_history" ~/
        
        log_success "Configuration files restored"
    fi
    
    # Restore code projects
    if [ -d "$backup_path/code" ]; then
        log_info "Restoring code projects..."
        rm -rf ~/code
        cp -r "$backup_path/code" ~/
        log_success "Code projects restored"
    fi
    
    log_success "Backup restored successfully"
    log_info "Please restart your terminal for changes to take effect"
}

# Cleanup old backups
cleanup_old_backups() {
    log_info "Cleaning up old backups..."
    
    if [ -d "$BACKUP_DIR" ]; then
        # Keep only last 10 backups
        cd "$BACKUP_DIR"
        ls -t | grep -E "(backup|dev-env-backup)" | tail -n +11 | xargs -r rm -rf
        log_success "Old backups cleaned up"
    fi
}

# Show backup info
show_backup_info() {
    local backup_name="$1"
    
    if [ -z "$backup_name" ]; then
        log_error "Please specify backup name"
        list_backups
        exit 1
    fi
    
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [ -f "$backup_path.tar.gz" ]; then
        backup_path="$BACKUP_DIR/$backup_name.tar.gz"
    fi
    
    if [ ! -d "$backup_path" ] && [ ! -f "$backup_path" ]; then
        log_error "Backup not found: $backup_name"
        list_backups
        exit 1
    fi
    
    log_info "Backup Information: $backup_name"
    
    if [ -f "$backup_path" ]; then
        echo "Type: Compressed archive"
        echo "Size: $(du -h "$backup_path" | cut -f1)"
        echo "Created: $(stat -f "%Sm" "$backup_path" 2>/dev/null || stat -c "%y" "$backup_path" 2>/dev/null || echo "Unknown")"
    else
        echo "Type: Directory"
        echo "Size: $(du -sh "$backup_path" | cut -f1)"
        echo "Created: $(stat -f "%Sm" "$backup_path" 2>/dev/null || stat -c "%y" "$backup_path" 2>/dev/null || echo "Unknown")"
        echo ""
        echo "Contents:"
        find "$backup_path" -type f | head -20
        if [ $(find "$backup_path" -type f | wc -l) -gt 20 ]; then
            echo "... and $(($(find "$backup_path" -type f | wc -l) - 20)) more files"
        fi
    fi
}

# Show help
show_help() {
    echo "Enhanced Backup System"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  create          Create a new backup"
    echo "  list            List available backups"
    echo "  restore         Restore from backup"
    echo "  info            Show backup information"
    echo "  cleanup         Clean up old backups"
    echo "  help            Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 create                    # Create new backup"
    echo "  $0 list                     # List all backups"
    echo "  $0 restore backup-name      # Restore from backup"
    echo "  $0 info backup-name         # Show backup info"
    echo "  $0 cleanup                  # Clean up old backups"
}

# Main function
main() {
    case "${1:-create}" in
        "create")
            create_backup_dir
            backup_dev_env
            backup_system_info
            create_backup_manifest
            compress_backup
            cleanup_old_backups
            log_success "Backup created successfully: $BACKUP_NAME"
            ;;
        "list")
            list_backups
            ;;
        "restore")
            restore_backup "$2"
            ;;
        "info")
            show_backup_info "$2"
            ;;
        "cleanup")
            cleanup_old_backups
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
