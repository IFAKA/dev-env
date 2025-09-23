#!/bin/bash

# Universal Development Environment Setup
# Phase 1: Foundation Setup

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging functions
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

log_header() {
    echo -e "${PURPLE}[PHASE 1]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
        exit 1
    fi
}

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        PACKAGE_MANAGER="brew"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        # Detect Linux package manager
        if command -v apt &> /dev/null; then
            PACKAGE_MANAGER="apt"
        elif command -v yum &> /dev/null; then
            PACKAGE_MANAGER="yum"
        elif command -v pacman &> /dev/null; then
            PACKAGE_MANAGER="pacman"
        elif command -v zypper &> /dev/null; then
            PACKAGE_MANAGER="zypper"
        elif command -v dnf &> /dev/null; then
            PACKAGE_MANAGER="dnf"
        else
            PACKAGE_MANAGER="unknown"
        fi
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        PLATFORM="windows"
        PACKAGE_MANAGER="chocolatey"
    elif [[ "$OSTYPE" == "android"* ]]; then
        PLATFORM="android"
        PACKAGE_MANAGER="pkg"
    elif [[ "$OSTYPE" == "ios"* ]]; then
        PLATFORM="ios"
        PACKAGE_MANAGER="apk"
    else
        log_error "Unsupported platform: $OSTYPE"
        log_info "Supported platforms: macOS, Linux, Windows, Android, iOS"
        exit 1
    fi
    
    log_info "Detected platform: $PLATFORM"
    log_info "Package manager: $PACKAGE_MANAGER"
}

# Check network connectivity
check_network_connectivity() {
    log_info "Checking network connectivity..."
    
    # Test connectivity to essential services
    local connectivity_ok=true
    
    # Test GitHub connectivity
    if ! curl -s --connect-timeout 10 https://github.com > /dev/null; then
        log_warning "GitHub connectivity failed"
        connectivity_ok=false
    fi
    
    # Test npm registry connectivity
    if ! curl -s --connect-timeout 10 https://registry.npmjs.org > /dev/null; then
        log_warning "NPM registry connectivity failed"
        connectivity_ok=false
    fi
    
    # Test PyPI connectivity
    if ! curl -s --connect-timeout 10 https://pypi.org > /dev/null; then
        log_warning "PyPI connectivity failed"
        connectivity_ok=false
    fi
    
    if [ "$connectivity_ok" = false ]; then
        log_warning "Network connectivity issues detected"
        log_info "Some features may not work properly"
        log_info "Consider running setup with --offline flag if available"
    else
        log_success "Network connectivity is good"
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check for required commands
    local missing_commands=()
    local optional_commands=()
    
    # Required commands
    if ! command -v git &> /dev/null; then
        missing_commands+=("git")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_commands+=("curl")
    fi
    
    # Optional commands
    if ! command -v wget &> /dev/null; then
        optional_commands+=("wget")
    fi
    
    if ! command -v unzip &> /dev/null; then
        optional_commands+=("unzip")
    fi
    
    if [ ${#missing_commands[@]} -ne 0 ]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        log_info "Please install the missing commands and run the setup again"
        exit 1
    fi
    
    if [ ${#optional_commands[@]} -ne 0 ]; then
        log_warning "Missing optional commands: ${optional_commands[*]}"
        log_info "Some features may not work optimally"
    fi
    
    # Check disk space
    local available_space
    case "$PLATFORM" in
        "macos"|"linux")
            available_space=$(df -h . | awk 'NR==2 {print $4}' | sed 's/[^0-9.]//g')
            if (( $(echo "$available_space < 5" | bc -l) )); then
                log_warning "Low disk space detected: ${available_space}GB available"
                log_info "Consider freeing up space before continuing"
            fi
            ;;
    esac
    
    # Check memory
    local total_memory
    case "$PLATFORM" in
        "macos")
            total_memory=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')
            ;;
        "linux")
            total_memory=$(free -g | awk 'NR==2{print $2}')
            ;;
    esac
    
    if [ -n "$total_memory" ] && (( $(echo "$total_memory < 4" | bc -l) )); then
        log_warning "Low memory detected: ${total_memory}GB total"
        log_info "Some operations may be slow"
    fi
    
    log_success "Prerequisites check completed"
}

# Install package manager
install_package_manager() {
    log_info "Installing package manager..."
    
    case "$PLATFORM" in
        "macos")
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
                    log_error "Homebrew installation failed"
                    log_info "Please install Homebrew manually: https://brew.sh"
                    exit 1
                fi
                
                # Add Homebrew to PATH
                if [[ -f "/opt/homebrew/bin/brew" ]]; then
                    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                elif [[ -f "/usr/local/bin/brew" ]]; then
                    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
                    eval "$(/usr/local/bin/brew shellenv)"
                else
                    log_error "Homebrew installation path not found"
                    exit 1
                fi
            else
                log_info "Homebrew already installed"
                # Update Homebrew
                log_info "Updating Homebrew..."
                brew update || log_warning "Homebrew update failed"
            fi
            ;;
        "linux")
            case "$PACKAGE_MANAGER" in
                "apt")
                    log_info "Using apt package manager"
                    sudo apt update || log_warning "apt update failed"
                    ;;
                "yum")
                    log_info "Using yum package manager"
                    sudo yum update -y || log_warning "yum update failed"
                    ;;
                "pacman")
                    log_info "Using pacman package manager"
                    sudo pacman -Sy || log_warning "pacman sync failed"
                    ;;
                "zypper")
                    log_info "Using zypper package manager"
                    sudo zypper refresh || log_warning "zypper refresh failed"
                    ;;
                "dnf")
                    log_info "Using dnf package manager"
                    sudo dnf update -y || log_warning "dnf update failed"
                    ;;
                *)
                    log_error "Unknown Linux package manager: $PACKAGE_MANAGER"
                    exit 1
                    ;;
            esac
            ;;
        "windows")
            log_info "Windows platform detected - using Chocolatey or manual installation"
            if ! command -v choco &> /dev/null; then
                log_info "Installing Chocolatey..."
                if ! powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"; then
                    log_error "Chocolatey installation failed"
                    log_info "Please install Chocolatey manually: https://chocolatey.org/install"
                    exit 1
                fi
            fi
            ;;
        "android")
            log_info "Android platform detected - using pkg package manager"
            if ! command -v pkg &> /dev/null; then
                log_error "pkg package manager not found"
                log_info "Please install Termux and run: pkg update"
                exit 1
            fi
            pkg update || log_warning "pkg update failed"
            ;;
        "ios")
            log_info "iOS platform detected - using apk package manager"
            if ! command -v apk &> /dev/null; then
                log_error "apk package manager not found"
                log_info "Please install iSH and run: apk update"
                exit 1
            fi
            apk update || log_warning "apk update failed"
            ;;
    esac
    
    log_success "Package manager ready"
}

# Install core tools
install_core_tools() {
    log_info "Installing core development tools..."
    
    case "$PLATFORM" in
        "macos")
            # Install via Homebrew
            brew install \
                neovim \
                lazygit \
                fzf \
                ripgrep \
                bat \
                eza \
                taskwarrior-tui \
                httpie \
                leetcode-cli
            ;;
        "linux")
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y \
                    neovim \
                    git \
                    curl \
                    wget \
                    build-essential \
                    fzf \
                    ripgrep \
                    bat \
                    eza \
                    taskwarrior-tui \
                    httpie \
                    python3 \
                    python3-pip
            elif command -v yum &> /dev/null; then
                sudo yum install -y \
                    neovim \
                    git \
                    curl \
                    wget \
                    gcc \
                    gcc-c++ \
                    make \
                    fzf \
                    ripgrep \
                    bat \
                    eza \
                    taskwarrior-tui \
                    httpie \
                    python3 \
                    python3-pip
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm \
                    neovim \
                    git \
                    curl \
                    wget \
                    base-devel \
                    fzf \
                    ripgrep \
                    bat \
                    eza \
                    taskwarrior-tui \
                    httpie \
                    python \
                    python-pip
            fi
            ;;
    esac
    
    log_success "Core tools installed"
}

# Install Node.js with NVM
install_nodejs() {
    log_info "Installing Node.js with NVM..."
    
    # Install NVM
    if ! command -v nvm &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        # Add NVM to shell profile
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
    else
        log_info "NVM already installed"
    fi
    
    # Load NVM for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
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
    
    log_success "Node.js and npm packages installed"
}

# Install Python packages
install_python_packages() {
    log_info "Installing Python packages..."
    
    # Install Python packages
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
        beautifulsoup4 \
        lxml
    
    log_success "Python packages installed"
}

# Create directory structure
create_directory_structure() {
    log_info "Creating directory structure..."
    
    # Create main directories
    mkdir -p ~/code
    mkdir -p ~/bin
    mkdir -p ~/.config/nvim
    mkdir -p ~/.local/share/nvim
    mkdir -p ~/.cache/nvim
    
    # Create project directories
    mkdir -p ~/code/sfcc-projects
    mkdir -p ~/code/nextjs-projects
    mkdir -p ~/code/ai-projects
    mkdir -p ~/code/data-projects
    
    log_success "Directory structure created"
}

# Setup shell configuration
setup_shell_config() {
    log_info "Setting up shell configuration..."
    
    # Create zsh aliases
    cat > ~/.zsh_aliases << 'EOF'
# Development aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"

# Neovim aliases
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="eza -la"
alias la="eza -la"
alias ls="eza"
alias cat="bat"

# Development shortcuts
alias lg="lazygit"
alias tk="taskwarrior-tui"
alias lc="leetcode"
alias http="httpie"

# Project navigation
alias code="cd ~/code"
alias sfcc="cd ~/code/sfcc-projects"
alias nextjs="cd ~/code/nextjs-projects"
alias ai="cd ~/code/ai-projects"
alias data="cd ~/code/data-projects"

# Docker shortcuts
alias docker-manager="./scripts/docker-manager.sh"
alias docker-dev="docker-manager start-dev"
alias docker-sfcc="docker-manager start-sfcc"
alias docker-ai="docker-manager start-ai"
alias docker-data="docker-manager start-data"
EOF

    # Add aliases to zshrc
    echo 'source ~/.zsh_aliases' >> ~/.zshrc
    
    log_success "Shell configuration created"
}

# Setup Git configuration
setup_git_config() {
    log_info "Setting up Git configuration..."
    
    # Set Git user if not already set
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Enter your Git username: " git_username
        git config --global user.name "$git_username"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Enter your Git email: " git_email
        git config --global user.email "$git_email"
    fi
    
    # Set Git aliases
    git config --global alias.s status
    git config --global alias.a add
    git config --global alias.c commit
    git config --global alias.p push
    git config --global alias.l pull
    git config --global alias.d diff
    git config --global alias.b branch
    git config --global alias.co checkout
    
    log_success "Git configuration completed"
}

# Copy Neovim configuration
copy_nvim_config() {
    log_info "Copying Neovim configuration..."
    
    # Copy Neovim config
    cp -r configs/nvim/* ~/.config/nvim/
    
    log_success "Neovim configuration copied"
}

# Auto-configure fonts for proper icon display
configure_fonts() {
    log_info "Auto-configuring fonts for icon display..."
    
    if [ -f "scripts/auto-font-setup.sh" ]; then
        chmod +x scripts/auto-font-setup.sh
        ./scripts/auto-font-setup.sh > /dev/null 2>&1
        log_success "Font configuration completed"
    else
        log_warning "Font setup script not found - icons may display as squares"
    fi
}

# Fix zsh compinit insecure files issue
fix_zsh_compinit() {
    log_info "Fixing zsh compinit insecure files issue..."
    
    if [ -f "scripts/fix-zsh-compinit.sh" ]; then
        chmod +x scripts/fix-zsh-compinit.sh
        ./scripts/fix-zsh-compinit.sh > /dev/null 2>&1
        log_success "ZSH compinit issue fixed"
    else
        log_warning "ZSH compinit fix script not found"
    fi
}

# Make scripts executable
make_scripts_executable() {
    log_info "Making scripts executable..."
    
    chmod +x scripts/*.sh
    chmod +x scripts/docker/*.sh
    chmod +x scripts/docker/*/*.sh
    
    log_success "Scripts made executable"
}

# Validate installation
validate_installation() {
    log_info "Validating installation..."
    
    local errors=0
    
    # Check if tools are available
    local tools=("nvim" "lazygit" "fzf" "rg" "bat" "eza" "taskwarrior-tui" "http" "leetcode")
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "$tool not found"
            ((errors++))
        fi
    done
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js not found"
        ((errors++))
    fi
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 not found"
        ((errors++))
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "All tools are properly installed"
    else
        log_error "Installation validation failed with $errors errors"
        exit 1
    fi
}

# Rollback function
rollback_setup() {
    log_error "Setup failed. Rolling back changes..."
    
    # Remove created directories
    rm -rf ~/code 2>/dev/null || true
    rm -rf ~/bin 2>/dev/null || true
    
    # Remove shell configuration
    if [ -f ~/.zsh_aliases ]; then
        rm ~/.zsh_aliases
        # Remove alias source from zshrc
        sed -i '/source ~\/.zsh_aliases/d' ~/.zshrc 2>/dev/null || true
    fi
    
    # Remove NVM if it was installed
    if [ -d ~/.nvm ]; then
        rm -rf ~/.nvm
        # Remove NVM from shell profile
        sed -i '/NVM_DIR/d' ~/.zshrc 2>/dev/null || true
        sed -i '/nvm.sh/d' ~/.zshrc 2>/dev/null || true
    fi
    
    # Remove Homebrew if it was installed
    if [ -f /opt/homebrew/bin/brew ] || [ -f /usr/local/bin/brew ]; then
        log_warning "Homebrew was installed. Manual removal may be required."
        log_info "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
    fi
    
    log_info "Rollback completed"
}

# Error handler
error_handler() {
    local exit_code=$?
    log_error "Setup failed with exit code: $exit_code"
    rollback_setup
    exit $exit_code
}

# Set error handler
trap error_handler ERR

# Main setup function
main() {
    log_header "Starting Universal Development Environment Setup"
    
    # Parse command line arguments
    local offline_mode=false
    local skip_validation=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --offline)
                offline_mode=true
                shift
                ;;
            --skip-validation)
                skip_validation=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--offline] [--skip-validation] [--help]"
                echo "  --offline          Skip network-dependent operations"
                echo "  --skip-validation  Skip installation validation"
                echo "  --help            Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Check if running as root
    check_root
    
    # Detect platform
    detect_platform
    
    # Check prerequisites
    check_prerequisites
    
    # Check network connectivity (unless offline mode)
    if [ "$offline_mode" = false ]; then
        check_network_connectivity
    else
        log_info "Offline mode enabled - skipping network operations"
    fi
    
    # Install package manager
    install_package_manager
    
    # Install core tools
    install_core_tools
    
    # Install Node.js (unless offline mode)
    if [ "$offline_mode" = false ]; then
        install_nodejs
    else
        log_info "Skipping Node.js installation (offline mode)"
    fi
    
    # Install Python packages (unless offline mode)
    if [ "$offline_mode" = false ]; then
        install_python_packages
    else
        log_info "Skipping Python packages installation (offline mode)"
    fi
    
    # Create directory structure
    create_directory_structure
    
    # Setup shell configuration
    setup_shell_config
    
    # Setup Git configuration
    setup_git_config
    
    # Copy Neovim configuration
    copy_nvim_config
    
    # Configure fonts for proper icon display
    configure_fonts
    
    # Fix zsh compinit insecure files issue
    fix_zsh_compinit
    
    # Make scripts executable
    make_scripts_executable
    
    # Validate installation (unless skipped)
    if [ "$skip_validation" = false ]; then
        validate_installation
    else
        log_info "Skipping installation validation"
    fi
    
    log_success "Phase 1: Foundation Setup completed successfully!"
    log_info "Please restart your terminal or run: source ~/.zshrc"
    log_info "Next: Run Phase 2: Cross-Device Sync"
}

# Run main function
main "$@"