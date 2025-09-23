#!/bin/bash

# iOS/iSH Mobile Configuration
# Optimized for iOS development with external keyboard

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

# iOS/iSH specific setup
setup_ios_ish() {
    log_info "Setting up iOS/iSH mobile development..."
    
    # Setup mobile-specific paths
    MOBILE_CODE_DIR="$HOME/Code"
    mkdir -p "$MOBILE_CODE_DIR"
    
    # Set environment variables
    export TERM=xterm-256color
    export COLORTERM=truecolor
    
    # Mobile-specific aliases
    cat >> ~/.zshrc << 'EOF'
# iOS/iSH mobile aliases
alias code="cd ~/Code"
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
    apk update
    apk add git neovim nodejs npm python3
    apk add fzf ripgrep bat exa lazygit
    apk add build-base cmake pkgconfig
    
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
    
    log_success "iOS/iSH setup completed"
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
            setup_ios_ish
            ;;
        "dev")
            mobile_dev_workflow
            ;;
        "sync")
            mobile_sync_setup
            ;;
        *)
            echo "Usage: $0 [setup|dev|sync]"
            echo "  setup - Setup iOS/iSH environment"
            echo "  dev   - Start mobile development workflow"
            echo "  sync  - Setup mobile sync"
            ;;
    esac
}

# Run main function
main "$@"
