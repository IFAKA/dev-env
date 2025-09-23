#!/bin/bash

# Android/Termux Mobile Configuration
# Optimized for Android development with external keyboard

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Android/Termux specific setup
setup_android_termux() {
    log_info "Setting up Android/Termux mobile development..."
    
    # Ensure Termux storage permission
    if command -v termux-setup-storage &> /dev/null; then
        log_info "Setting up Termux storage permissions..."
        termux-setup-storage
    fi
    
    # Setup mobile-specific paths
    MOBILE_CODE_DIR="$HOME/storage/shared/Code"
    mkdir -p "$MOBILE_CODE_DIR"
    
    # Set environment variables
    export TERMUX_HOME="/data/data/com.termux/files/home"
    export PATH="$TERMUX_HOME/bin:$PATH"
    export HOME="$TERMUX_HOME"
    
    # Mobile-specific aliases
    cat >> ~/.zshrc << 'EOF'
# Android/Termux mobile aliases
alias code="cd ~/storage/shared/Code"
alias sync="~/dev-env/scripts/sync.sh"
alias backup="~/dev-env/scripts/backup-system.sh"
alias mobile="~/dev-env/scripts/mobile.sh"
alias dev="~/dev-env/scripts/start-dev.sh"

# Mobile development shortcuts
alias v="nvim"
alias lg="lazygit"
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
EOF
    
    # Install essential packages
    log_info "Installing essential packages..."
    pkg update
    pkg install -y git neovim nodejs npm python3
    pkg install -y fzf ripgrep bat exa lazygit
    pkg install -y termux-api termux-elf-cleaner
    
    # Setup Node.js with NVM
    if ! command -v nvm &> /dev/null; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
    
    # Install Node.js versions
    nvm install 14  # For SFCC
    nvm install 18  # For modern development
    nvm install 20  # Latest LTS
    nvm use 18      # Set default
    
    # Install global npm packages
    npm install -g \
        typescript \
        typescript-language-server \
        eslint \
        prettier \
        dwupload \
        leetcode-cli
    
    # Setup Python packages
    pip3 install --upgrade pip
    pip3 install \
        jupyter \
        ipykernel \
        pandas \
        numpy \
        matplotlib \
        seaborn \
        plotly \
        scikit-learn \
        requests \
        beautifulsoup4
    
    log_success "Android/Termux setup completed"
}

# Mobile development workflow
mobile_dev_workflow() {
    log_info "Starting mobile development workflow..."
    
    # Check if we're in a project directory
    if [ -f "package.json" ] || [ -f "dw.json" ] || [ -f "requirements.txt" ]; then
        log_info "Project detected. Starting mobile development..."
        
        # Start appropriate development server
        if [ -f "package.json" ]; then
            log_info "Node.js project detected"
            if [ -f "next.config.js" ] || [ -f "next.config.mjs" ]; then
                log_info "Starting Next.js development server..."
                npm run dev &
            elif [ -f "vue.config.js" ]; then
                log_info "Starting Vue development server..."
                npm run serve &
            else
                log_info "Starting Node.js development server..."
                npm start &
            fi
        elif [ -f "dw.json" ]; then
            log_info "SFCC project detected"
            log_info "Starting SFCC development..."
        elif [ -f "requirements.txt" ]; then
            log_info "Python project detected"
            log_info "Starting Python development..."
        fi
        
        # Open Neovim
        log_info "Opening Neovim..."
        nvim .
    else
        log_info "No project detected. Opening Neovim in current directory..."
        nvim .
    fi
}

# Mobile sync setup
mobile_sync_setup() {
    log_info "Setting up mobile sync..."
    
    # Setup sync directory
    mkdir -p ~/dev-env
    
    # Copy dev-env to mobile device
    if [ ! -d ~/dev-env ]; then
        log_info "Setting up dev-env on mobile device..."
        # This would typically be done via git clone
        # git clone <your-repo-url> ~/dev-env
    fi
    
    # Setup mobile sync
    cd ~/dev-env
    ./scripts/sync.sh setup
    
    log_success "Mobile sync setup completed"
}

# Main function
main() {
    case "${1:-setup}" in
        "setup")
            setup_android_termux
            ;;
        "dev")
            mobile_dev_workflow
            ;;
        "sync")
            mobile_sync_setup
            ;;
        *)
            echo "Usage: $0 [setup|dev|sync]"
            echo "  setup - Setup Android/Termux environment"
            echo "  dev   - Start mobile development workflow"
            echo "  sync  - Setup mobile sync"
            ;;
    esac
}

# Run main function
main "$@"
