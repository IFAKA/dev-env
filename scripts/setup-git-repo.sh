#!/bin/bash

# Git Repository Setup Script
# Sets up the dev-env repository for cross-device synchronization

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
REPO_DIR="$HOME/dev-env"
GITHUB_USERNAME=""
GITHUB_REPO_NAME="dev-env"

# Get GitHub username
get_github_username() {
    if [ -z "$GITHUB_USERNAME" ]; then
        read -p "Enter your GitHub username: " GITHUB_USERNAME
        if [ -z "$GITHUB_USERNAME" ]; then
            log_error "GitHub username is required"
            exit 1
        fi
    fi
    log_info "Using GitHub username: $GITHUB_USERNAME"
}

# Initialize Git repository
init_git_repo() {
    log_info "Initializing Git repository..."
    
    cd "$REPO_DIR"
    
    # Initialize git if not already initialized
    if [ ! -d ".git" ]; then
        git init
        log_success "Git repository initialized"
    else
        log_info "Git repository already initialized"
    fi
    
    # Set default branch to main
    git branch -M main
    
    # Add all files
    git add .
    
    # Create initial commit
    git commit -m "Initial commit: Universal Development Environment" || true
    
    log_success "Git repository setup completed"
}

# Setup GitHub remote
setup_github_remote() {
    log_info "Setting up GitHub remote..."
    
    cd "$REPO_DIR"
    
    # Remove existing origin if it exists
    git remote remove origin 2>/dev/null || true
    
    # Add GitHub remote
    git remote add origin "git@github.com:$GITHUB_USERNAME/$GITHUB_REPO_NAME.git"
    
    log_success "GitHub remote configured: git@github.com:$GITHUB_USERNAME/$GITHUB_REPO_NAME.git"
}

# Create GitHub repository
create_github_repo() {
    log_info "Creating GitHub repository..."
    
    # Check if GitHub CLI is available
    if command -v gh &> /dev/null; then
        log_info "Using GitHub CLI to create repository..."
        
        # Create repository on GitHub
        gh repo create "$GITHUB_REPO_NAME" --private --description "Universal Development Environment" --clone=false || {
            log_warning "Repository might already exist or GitHub CLI authentication failed"
        }
        
        log_success "GitHub repository created"
    else
        log_warning "GitHub CLI not found. Please create the repository manually:"
        log_info "1. Go to https://github.com/new"
        log_info "2. Repository name: $GITHUB_REPO_NAME"
        log_info "3. Description: Universal Development Environment"
        log_info "4. Make it private"
        log_info "5. Don't initialize with README, .gitignore, or license"
        log_info "6. Click 'Create repository'"
        
        read -p "Press Enter when you've created the repository..."
    fi
}

# Setup Git configuration
setup_git_config() {
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
    git config --global core.autocrlf input
    git config --global core.safecrlf true
    
    log_success "Git configuration completed"
}

# Setup SSH key
setup_ssh_key() {
    log_info "Setting up SSH key..."
    
    # Create SSH directory
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    # Generate SSH key if it doesn't exist
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
        log_success "SSH key generated"
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
    
    # Display public key
    log_info "Add this public key to your GitHub account:"
    echo "https://github.com/settings/keys"
    echo ""
    cat ~/.ssh/id_rsa.pub
    echo ""
    read -p "Press Enter when you've added the SSH key to GitHub..."
}

# Push to GitHub
push_to_github() {
    log_info "Pushing to GitHub..."
    
    cd "$REPO_DIR"
    
    # Push to GitHub
    git push -u origin main || {
        log_error "Failed to push to GitHub. Please check your SSH key and repository settings."
        exit 1
    }
    
    log_success "Successfully pushed to GitHub"
}

# Validate setup
validate_setup() {
    log_info "Validating Git repository setup..."
    
    cd "$REPO_DIR"
    
    # Check if git repository is initialized
    if [ ! -d ".git" ]; then
        log_error "Git repository not initialized"
        return 1
    fi
    
    # Check if remote is configured
    if ! git remote get-url origin &> /dev/null; then
        log_error "GitHub remote not configured"
        return 1
    fi
    
    # Check if we can connect to GitHub
    if ! ssh -T git@github.com &> /dev/null; then
        log_warning "Cannot connect to GitHub. Please check your SSH key."
        return 1
    fi
    
    log_success "Git repository setup validation passed"
}

# Show repository info
show_repo_info() {
    log_info "Repository Information:"
    echo "  Local path: $REPO_DIR"
    echo "  GitHub URL: https://github.com/$GITHUB_USERNAME/$GITHUB_REPO_NAME"
    echo "  Clone URL: git@github.com:$GITHUB_USERNAME/$GITHUB_REPO_NAME.git"
    echo ""
    log_info "To sync on other devices:"
    echo "  git clone git@github.com:$GITHUB_USERNAME/$GITHUB_REPO_NAME.git ~/dev-env"
    echo "  cd ~/dev-env"
    echo "  ./scripts/sync.sh setup"
}

# Main function
main() {
    log_info "Setting up Git repository for cross-device sync..."
    
    # Get GitHub username
    get_github_username
    
    # Setup Git configuration
    setup_git_config
    
    # Setup SSH key
    setup_ssh_key
    
    # Initialize Git repository
    init_git_repo
    
    # Create GitHub repository
    create_github_repo
    
    # Setup GitHub remote
    setup_github_remote
    
    # Push to GitHub
    push_to_github
    
    # Validate setup
    validate_setup
    
    # Show repository info
    show_repo_info
    
    log_success "Git repository setup completed successfully!"
    log_info "Your development environment is now ready for cross-device synchronization."
}

# Run main function
main "$@"
