#!/bin/bash

# Cross-Device Synchronization Script
# Syncs your development environment across all devices using Git + GitHub

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
SYNC_DIR="$HOME/dev-env"
REMOTE_REPO="git@github.com:your-username/dev-env.git"
BACKUP_DIR="$HOME/dev-backup"
EXCLUDE_FILE="$HOME/.sync-exclude"
CONFLICT_RESOLUTION="auto"  # auto, manual, skip
MAX_BACKUPS=10
SYNC_TIMEOUT=300  # 5 minutes

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
    elif [[ "$OSTYPE" == "android"* ]]; then
        PLATFORM="android"
    elif [[ "$OSTYPE" == "ios"* ]]; then
        PLATFORM="ios"
    else
        PLATFORM="unknown"
    fi
    
    log_info "Detected platform: $PLATFORM"
}

# Create exclude file
create_exclude_file() {
    log_info "Creating sync exclude file..."
    
    cat > "$EXCLUDE_FILE" << 'EOF'
# Sync exclude patterns
node_modules/
.git/
.vscode/
.idea/
*.log
*.tmp
*.swp
*.swo
*~
.DS_Store
Thumbs.db
*.pid
*.lock
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
dist/
build/
coverage/
.nyc_output/
.cache/
.next/
.nuxt/
.vuepress/dist/
.serverless/
.fusebox/
.dynamodb/
.tern-port
.vscode-test/
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*
EOF
    
    log_success "Exclude file created"
}

# Setup sync directory
setup_sync_dir() {
    log_info "Setting up sync directory..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Initialize git repository if it doesn't exist
    if [ ! -d "$SYNC_DIR/.git" ]; then
        cd "$SYNC_DIR"
        git init
        git remote add origin "$REMOTE_REPO"
        log_success "Git repository initialized"
    fi
    
    log_success "Sync directory setup completed"
}

# Backup current state
backup_current() {
    log_info "Creating backup of current state..."
    
    # Create timestamped backup
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"
    
    mkdir -p "$BACKUP_PATH"
    
    # Backup important directories
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/code/ "$BACKUP_PATH/code/"
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/docs/ "$BACKUP_PATH/docs/"
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/scripts/ "$BACKUP_PATH/scripts/"
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/.config/ "$BACKUP_PATH/config/"
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/.zshrc "$BACKUP_PATH/"
    rsync -avz --exclude-from="$EXCLUDE_FILE" ~/.zsh_aliases "$BACKUP_PATH/"
    
    log_success "Backup created: $BACKUP_PATH"
}

# Check for conflicts
check_conflicts() {
    log_info "Checking for conflicts..."
    
    cd "$SYNC_DIR"
    
    # Check if there are uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        log_warning "Uncommitted changes detected"
        return 1
    fi
    
    # Check if remote has changes
    git fetch origin main
    if ! git diff --quiet HEAD origin/main; then
        log_warning "Remote has changes that need to be pulled"
        return 1
    fi
    
    log_success "No conflicts detected"
    return 0
}

# Resolve conflicts
resolve_conflicts() {
    log_info "Resolving conflicts..."
    
    cd "$SYNC_DIR"
    
    case "$CONFLICT_RESOLUTION" in
        "auto")
            log_info "Auto-resolving conflicts..."
            # Auto-resolve by taking local changes
            git checkout --ours .
            git add .
            git commit -m "Auto-resolve conflicts: $(date '+%Y-%m-%d %H:%M:%S')"
            ;;
        "manual")
            log_info "Manual conflict resolution required"
            log_info "Please resolve conflicts manually and run sync again"
            return 1
            ;;
        "skip")
            log_info "Skipping conflict resolution"
            return 1
            ;;
    esac
    
    log_success "Conflicts resolved"
}

# Sync to remote
sync_to_remote() {
    log_info "Syncing to remote repository..."
    
    cd "$SYNC_DIR"
    
    # Check for conflicts first
    if ! check_conflicts; then
        log_info "Attempting to resolve conflicts..."
        if ! resolve_conflicts; then
            log_error "Cannot sync due to conflicts"
            return 1
        fi
    fi
    
    # Add all files
    git add .
    
    # Check if there are changes to commit
    if git diff --cached --quiet; then
        log_info "No changes to commit"
        return 0
    fi
    
    # Commit changes
    git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S')" || {
        log_error "Failed to commit changes"
        return 1
    }
    
    # Push to remote with timeout
    if timeout "$SYNC_TIMEOUT" git push origin main; then
        log_success "Synced to remote"
    else
        log_error "Failed to push to remote (timeout or error)"
        return 1
    fi
}

# Sync from remote
sync_from_remote() {
    log_info "Syncing from remote repository..."
    
    cd "$SYNC_DIR"
    
    # Check if remote is accessible
    if ! git ls-remote origin main &> /dev/null; then
        log_error "Cannot access remote repository"
        return 1
    fi
    
    # Pull latest changes with timeout
    if timeout "$SYNC_TIMEOUT" git pull origin main; then
        log_success "Pulled latest changes"
    else
        log_error "Failed to pull from remote (timeout or error)"
        return 1
    fi
    
    # Create backup before syncing
    backup_current
    
    # Sync files to home directory with error handling
    local sync_errors=0
    
    if [ -d "$SYNC_DIR/code/" ]; then
        rsync -avz --exclude-from="$EXCLUDE_FILE" "$SYNC_DIR/code/" ~/code/ || {
            log_warning "Failed to sync code directory"
            ((sync_errors++))
        }
    fi
    
    if [ -d "$SYNC_DIR/docs/" ]; then
        rsync -avz --exclude-from="$EXCLUDE_FILE" "$SYNC_DIR/docs/" ~/docs/ || {
            log_warning "Failed to sync docs directory"
            ((sync_errors++))
        }
    fi
    
    if [ -d "$SYNC_DIR/scripts/" ]; then
        rsync -avz --exclude-from="$EXCLUDE_FILE" "$SYNC_DIR/scripts/" ~/scripts/ || {
            log_warning "Failed to sync scripts directory"
            ((sync_errors++))
        }
    fi
    
    if [ -d "$SYNC_DIR/config/" ]; then
        rsync -avz --exclude-from="$EXCLUDE_FILE" "$SYNC_DIR/config/" ~/.config/ || {
            log_warning "Failed to sync config directory"
            ((sync_errors++))
        }
    fi
    
    # Sync shell configuration files
    if [ -f "$SYNC_DIR/.zshrc" ]; then
        cp "$SYNC_DIR/.zshrc" ~/.zshrc || {
            log_warning "Failed to sync .zshrc"
            ((sync_errors++))
        }
    fi
    
    if [ -f "$SYNC_DIR/.zsh_aliases" ]; then
        cp "$SYNC_DIR/.zsh_aliases" ~/.zsh_aliases || {
            log_warning "Failed to sync .zsh_aliases"
            ((sync_errors++))
        }
    fi
    
    if [ $sync_errors -eq 0 ]; then
        log_success "Synced from remote"
    else
        log_warning "Sync completed with $sync_errors errors"
    fi
}

# Sync local files
sync_local() {
    log_info "Syncing local files..."
    
    # Add all files to git
    cd "$SYNC_DIR"
    git add .
    
    log_success "Local sync completed"
}

# Setup SSH for GitHub sync
setup_ssh() {
    log_info "Setting up SSH for GitHub sync..."
    
    # Create SSH directory
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    # Generate SSH key if it doesn't exist
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
        log_success "SSH key generated"
        log_info "Add this public key to your GitHub account:"
        cat ~/.ssh/id_rsa.pub
    else
        log_success "SSH key already exists"
    fi
    
    # Setup SSH config for GitHub
    cat > ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
EOF
    
    chmod 600 ~/.ssh/config
    
    log_success "SSH configuration completed"
}

# Mobile-specific sync setup
setup_mobile_sync() {
    log_info "Setting up mobile sync..."
    
    case "$PLATFORM" in
        "android")
            # Android/Termux specific setup
            log_info "Configuring Android/Termux sync..."
            
            # Ensure Termux storage permission
            if command -v termux-setup-storage &> /dev/null; then
                termux-setup-storage
            fi
            
            # Setup mobile-specific paths
            MOBILE_CODE_DIR="$HOME/storage/shared/Code"
            mkdir -p "$MOBILE_CODE_DIR"
            
            # Create mobile-specific aliases
            cat >> ~/.zshrc << 'EOF'
# Mobile development aliases
alias code="cd ~/storage/shared/Code"
alias sync="~/dev-env/scripts/sync.sh"
EOF
            ;;
        "ios")
            # iOS/iSH specific setup
            log_info "Configuring iOS/iSH sync..."
            
            # Setup mobile-specific paths
            MOBILE_CODE_DIR="$HOME/Code"
            mkdir -p "$MOBILE_CODE_DIR"
            
            # Create mobile-specific aliases
            cat >> ~/.zshrc << 'EOF'
# Mobile development aliases
alias code="cd ~/Code"
alias sync="~/dev-env/scripts/sync.sh"
EOF
            ;;
    esac
    
    log_success "Mobile sync setup completed"
}

# Setup Git configuration
setup_git() {
    log_info "Setting up Git configuration..."
    
    # Set Git user if not set
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Enter your Git username: " git_username
        read -p "Enter your Git email: " git_email
        git config --global user.name "$git_username"
        git config --global user.email "$git_email"
    fi
    
    # Set Git configuration
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global push.default simple
    
    log_success "Git configuration completed"
}

# Validate sync
validate_sync() {
    log_info "Validating sync..."
    
    # Check if sync directory exists
    if [ ! -d "$SYNC_DIR" ]; then
        log_error "Sync directory not found"
        return 1
    fi
    
    # Check if git repository is initialized
    if [ ! -d "$SYNC_DIR/.git" ]; then
        log_error "Git repository not initialized"
        return 1
    fi
    
    # Check if remote is configured
    if ! git -C "$SYNC_DIR" remote get-url origin &> /dev/null; then
        log_error "GitHub repository not configured"
        return 1
    fi
    
    log_success "Sync validation passed"
}

# Cleanup old backups
cleanup_backups() {
    log_info "Cleaning up old backups..."
    
    # Keep only last 10 backups
    cd "$BACKUP_DIR"
    ls -t | tail -n +11 | xargs -r rm -rf
    
    log_success "Old backups cleaned up"
}

# Check network connectivity
check_network() {
    log_info "Checking network connectivity..."
    
    # Test GitHub connectivity
    if ! curl -s --connect-timeout 10 https://github.com > /dev/null; then
        log_error "Cannot connect to GitHub"
        return 1
    fi
    
    # Test SSH connectivity to GitHub
    if ! ssh -T git@github.com &> /dev/null; then
        log_warning "SSH connection to GitHub failed"
        log_info "Please check your SSH key configuration"
    fi
    
    log_success "Network connectivity is good"
}

# Main sync function
main_sync() {
    log_info "Starting synchronization..."
    
    # Check network connectivity
    if ! check_network; then
        log_error "Network connectivity check failed"
        return 1
    fi
    
    # Create exclude file
    create_exclude_file
    
    # Setup sync directory
    setup_sync_dir
    
    # Backup current state
    backup_current
    
    # Sync local files
    sync_local
    
    # Sync to remote
    if ! sync_to_remote; then
        log_error "Failed to sync to remote"
        return 1
    fi
    
    # Cleanup old backups
    cleanup_backups
    
    log_success "Synchronization completed"
}

# Pull sync function
pull_sync() {
    log_info "Starting pull synchronization..."
    
    # Check network connectivity
    if ! check_network; then
        log_error "Network connectivity check failed"
        return 1
    fi
    
    # Setup sync directory
    setup_sync_dir
    
    # Sync from remote
    if ! sync_from_remote; then
        log_error "Failed to sync from remote"
        return 1
    fi
    
    log_success "Pull synchronization completed"
}

# Setup sync function
setup_sync() {
    log_info "Setting up synchronization..."
    
    # Detect platform
    detect_platform
    
    # Create exclude file
    create_exclude_file
    
    # Setup sync directory
    setup_sync_dir
    
    # Setup SSH
    setup_ssh
    
    # Setup Git
    setup_git
    
    # Setup mobile sync if needed
    if [[ "$PLATFORM" == "android" ]] || [[ "$PLATFORM" == "ios" ]]; then
        setup_mobile_sync
    fi
    
    # Validate sync
    validate_sync
    
    log_success "Synchronization setup completed"
}

# Show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  sync      Sync to remote repository"
    echo "  pull      Pull from remote repository"
    echo "  setup     Setup synchronization"
    echo "  backup    Create backup only"
    echo "  validate  Validate sync configuration"
    echo "  help      Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 sync      # Sync to remote"
    echo "  $0 pull      # Pull from remote"
    echo "  $0 setup     # Setup synchronization"
}

# Main function
main() {
    case "${1:-sync}" in
        "sync")
            main_sync
            ;;
        "pull")
            pull_sync
            ;;
        "setup")
            setup_sync
            ;;
        "backup")
            backup_current
            ;;
        "validate")
            validate_sync
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

