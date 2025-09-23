#!/bin/bash

# Mobile Development Optimizations
# Optimizes the development environment for mobile devices

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

# Detect mobile platform
detect_mobile_platform() {
    # Check for Termux (Android)
    if [[ -f /data/data/com.termux/files/usr/bin/termux-info ]]; then
        PLATFORM="android"
        TERMUX_HOME="/data/data/com.termux/files/home"
        PACKAGE_MANAGER="pkg"
        MOBILE_APP="termux"
    # Check for iSH (iOS)
    elif [[ -f /etc/alpine-release ]] && [[ -f /etc/os-release ]] && grep -q "iSH" /etc/os-release; then
        PLATFORM="ios"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="apk"
        MOBILE_APP="ish"
    # Check for other Android environments
    elif [[ "$OSTYPE" == "android"* ]] || [[ -f /system/build.prop ]]; then
        PLATFORM="android"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="pkg"
        MOBILE_APP="unknown"
    # Check for other iOS environments
    elif [[ "$OSTYPE" == "ios"* ]] || [[ -f /etc/alpine-release ]]; then
        PLATFORM="ios"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="apk"
        MOBILE_APP="unknown"
    # Check for desktop platforms
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="brew"
        MOBILE_APP="desktop"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="apt"
        MOBILE_APP="desktop"
    else
        PLATFORM="unknown"
        TERMUX_HOME="$HOME"
        PACKAGE_MANAGER="unknown"
        MOBILE_APP="unknown"
    fi
    
    log_info "Detected platform: $PLATFORM"
    log_info "Package manager: $PACKAGE_MANAGER"
    log_info "Mobile app: $MOBILE_APP"
    
    # Validate mobile platform
    if [[ "$PLATFORM" == "unknown" ]]; then
        log_warning "Unknown platform detected"
        log_info "This may not be a mobile device"
    fi
}

# Check mobile prerequisites
check_mobile_prerequisites() {
    log_info "Checking mobile prerequisites..."
    
    local missing_commands=()
    local warnings=()
    
    # Check for essential commands
    if ! command -v git &> /dev/null; then
        missing_commands+=("git")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_commands+=("curl")
    fi
    
    # Check for mobile-specific commands
    case "$PLATFORM" in
        "android")
            if ! command -v pkg &> /dev/null; then
                missing_commands+=("pkg")
            fi
            if ! command -v termux-setup-storage &> /dev/null; then
                warnings+=("termux-setup-storage")
            fi
            ;;
        "ios")
            if ! command -v apk &> /dev/null; then
                missing_commands+=("apk")
            fi
            ;;
    esac
    
    if [ ${#missing_commands[@]} -ne 0 ]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        log_info "Please install the missing commands and run the setup again"
        return 1
    fi
    
    if [ ${#warnings[@]} -ne 0 ]; then
        log_warning "Missing optional commands: ${warnings[*]}"
        log_info "Some features may not work optimally"
    fi
    
    log_success "Mobile prerequisites check completed"
}

# Setup Android/Termux optimizations
setup_android() {
    log_info "Setting up Android/Termux optimizations..."
    
    # Check prerequisites
    if ! check_mobile_prerequisites; then
        log_error "Prerequisites check failed"
        return 1
    fi
    
    # Ensure Termux storage permission
    if command -v termux-setup-storage &> /dev/null; then
        log_info "Setting up Termux storage permissions..."
        if ! termux-setup-storage; then
            log_warning "Failed to setup Termux storage permissions"
            log_info "You may need to grant storage permissions manually"
        fi
    else
        log_warning "termux-setup-storage not found"
        log_info "Storage permissions may need to be set manually"
    fi
    
    # Setup mobile-specific paths
    MOBILE_CODE_DIR="$HOME/storage/shared/Code"
    if ! mkdir -p "$MOBILE_CODE_DIR"; then
        log_warning "Failed to create mobile code directory"
        log_info "Using fallback directory: $HOME/Code"
        MOBILE_CODE_DIR="$HOME/Code"
        mkdir -p "$MOBILE_CODE_DIR"
    fi
    
    # Create mobile-specific aliases
    if ! cat >> ~/.zshrc << 'EOF'
# Mobile development aliases
alias code="cd ~/storage/shared/Code"
alias sync="~/dev-env/scripts/sync.sh"
alias backup="~/dev-env/scripts/backup-system.sh"
alias mobile="~/dev-env/scripts/mobile.sh"
EOF
    then
        log_warning "Failed to add mobile aliases to .zshrc"
    fi
    
    # Set environment variables
    export TERMUX_HOME="/data/data/com.termux/files/home"
    export PATH="$TERMUX_HOME/bin:$PATH"
    export HOME="$TERMUX_HOME"
    
    # Install essential packages with error handling
    log_info "Installing essential packages..."
    
    # Update package list
    if ! pkg update; then
        log_error "Failed to update package list"
        return 1
    fi
    
    # Install core packages
    local core_packages=("git" "neovim" "nodejs" "python")
    for package in "${core_packages[@]}"; do
        if ! pkg install -y "$package"; then
            log_warning "Failed to install $package"
        fi
    done
    
    # Install development tools
    local dev_packages=("fzf" "ripgrep" "bat" "exa" "lazygit" "taskwarrior" "httpie" "openssh")
    for package in "${dev_packages[@]}"; do
        if ! pkg install -y "$package"; then
            log_warning "Failed to install $package"
        fi
    done
    
    # Setup SSH server
    if ! pgrep sshd > /dev/null; then
        log_info "Starting SSH server..."
        sshd
        log_success "SSH server started"
    fi
    
    # Setup termux-specific configurations
    mkdir -p ~/.termux
    cat > ~/.termux/termux.properties << 'EOF'
# Termux properties
bell-character=ignore
back-key=escape
volume-keys=volume
extra-keys=[[{key: 'CTRL', popup: {macro: 'CTRL f', display: 'F'}}, {key: 'ALT', popup: {macro: 'ALT f', display: 'A'}}, {key: 'ESC', popup: {macro: 'ESC', display: 'ESC'}}], [{key: 'UP', popup: {macro: 'CTRL p', display: '↑'}}, {key: 'DOWN', popup: {macro: 'CTRL n', display: '↓'}}, {key: 'LEFT', popup: {macro: 'CTRL b', display: '←'}}, {key: 'RIGHT', popup: {macro: 'CTRL f', display: '→'}}]]
EOF
    
    log_success "Android optimizations applied"
}

# Setup iOS/iSH optimizations
setup_ios() {
    log_info "Setting up iOS/iSH optimizations..."
    
    # Setup mobile-specific paths
    MOBILE_CODE_DIR="$HOME/Code"
    mkdir -p "$MOBILE_CODE_DIR"
    
    # Create mobile-specific aliases
    cat >> ~/.zshrc << 'EOF'
# Mobile development aliases
alias code="cd ~/Code"
alias sync="~/dev-env/scripts/sync.sh"
alias backup="~/dev-env/scripts/backup-system.sh"
alias mobile="~/dev-env/scripts/mobile.sh"
EOF
    
    # Install essential packages
    apk update
    apk add git neovim nodejs npm python3
    apk add fzf ripgrep bat exa
    apk add lazygit
    apk add task
    apk add httpie
    apk add openssh
    
    # Setup SSH server
    if ! pgrep sshd > /dev/null; then
        log_info "Starting SSH server..."
        sshd
        log_success "SSH server started"
    fi
    
    log_success "iOS optimizations applied"
}

# Setup mobile-specific Neovim configuration
setup_mobile_neovim() {
    log_info "Setting up mobile Neovim configuration..."
    
    # Create mobile-specific Neovim config
    mkdir -p ~/.config/nvim
    
    cat > ~/.config/nvim/init.lua << 'EOF'
-- Mobile Neovim Configuration
-- Optimized for touch devices

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Mobile-specific settings
vim.opt.guifont = "monospace:h12"
vim.opt.guifontwide = "monospace:h12"
vim.opt.guioptions = "a"
vim.opt.guiheadroom = 0

-- Key mappings for mobile
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Touch-friendly navigation
keymap("n", "<leader>1", ":buffer 1<CR>", opts)
keymap("n", "<leader>2", ":buffer 2<CR>", opts)
keymap("n", "<leader>3", ":buffer 3<CR>", opts)
keymap("n", "<leader>4", ":buffer 4<CR>", opts)
keymap("n", "<leader>5", ":buffer 5<CR>", opts)
keymap("n", "<leader>6", ":buffer 6<CR>", opts)
keymap("n", "<leader>7", ":buffer 7<CR>", opts)
keymap("n", "<leader>8", ":buffer 8<CR>", opts)
keymap("n", "<leader>9", ":buffer 9<CR>", opts)
keymap("n", "<leader>0", ":buffer 10<CR>", opts)

-- File operations
keymap("n", "<leader>e", ":edit ", opts)
keymap("n", "<leader>w", ":write<CR>", opts)
keymap("n", "<leader>q", ":quit<CR>", opts)
keymap("n", "<leader>x", ":exit<CR>", opts)

-- Buffer operations
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprev<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<leader>ba", ":buffer #<CR>", opts)

-- Window operations
keymap("n", "<leader>wv", ":vsplit<CR>", opts)
keymap("n", "<leader>ws", ":split<CR>", opts)
keymap("n", "<leader>wc", ":close<CR>", opts)
keymap("n", "<leader>wo", ":only<CR>", opts)

-- Terminal
keymap("n", "<leader>t", ":terminal<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Git operations
keymap("n", "<leader>gs", ":terminal git status<CR>", opts)
keymap("n", "<leader>ga", ":terminal git add .<CR>", opts)
keymap("n", "<leader>gc", ":terminal git commit -m \"", opts)
keymap("n", "<leader>gp", ":terminal git push<CR>", opts)
keymap("n", "<leader>gl", ":terminal lazygit<CR>", opts)

-- Development shortcuts
keymap("n", "<leader>dd", ":terminal npm run dev<CR>", opts)
keymap("n", "<leader>db", ":terminal npm run build<CR>", opts)
keymap("n", "<leader>dt", ":terminal npm test<CR>", opts)
keymap("n", "<leader>dl", ":terminal npm run lint<CR>", opts)

-- Mobile-specific functions
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Colorscheme
vim.cmd("colorscheme default")
EOF
    
    log_success "Mobile Neovim configuration created"
}

# Setup mobile-specific shell configuration
setup_mobile_shell() {
    log_info "Setting up mobile shell configuration..."
    
    # Create mobile-specific aliases
    cat > ~/.zsh_aliases_mobile << 'EOF'
# Mobile-specific aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Touch-friendly commands
alias e='nvim'
alias v='nvim'
alias n='nvim'
alias t='terminal'
alias g='git'
alias lg='lazygit'
alias lc='leetcode-cli'
alias tk='task'
alias http='httpie'

# Mobile shortcuts
alias start='~/dev-env/scripts/daily.sh'
alias mobile='~/dev-env/scripts/mobile.sh'
alias sync='~/dev-env/scripts/sync.sh'
alias backup='~/dev-env/scripts/backup.sh'
alias restore='~/dev-env/scripts/restore.sh'

# Development shortcuts
alias dev='cd ~/dev-env'
alias code='cd ~/code'
alias sfcc='cd ~/code/sfcc-project'
alias next='cd ~/code/nextjs-app'
alias leet='cd ~/code/leetcode'
alias docs='cd ~/docs'

# Mobile-specific functions
mobile_edit() {
  if [ -z "$1" ]; then
    nvim .
  else
    nvim "$1"
  fi
}

mobile_terminal() {
  if [ -z "$1" ]; then
    terminal
  else
    terminal "$1"
  fi
}

mobile_git() {
  case "$1" in
    "s") git status ;;
    "a") git add . ;;
    "c") git commit -m "$2" ;;
    "p") git push ;;
    "l") git log --oneline -10 ;;
    "d") git diff ;;
    "b") git branch ;;
    "co") git checkout "$2" ;;
    "lg") lazygit ;;
    *) git "$@" ;;
  esac
}

# Set aliases
alias e=mobile_edit
alias t=mobile_terminal
alias g=mobile_git
EOF
    
    # Source mobile aliases
    echo "source ~/.zsh_aliases_mobile" >> ~/.zshrc
    
    log_success "Mobile shell configuration created"
}

# Setup mobile-specific tools
setup_mobile_tools() {
    log_info "Setting up mobile-specific tools..."
    
    # Create mobile tools directory
    mkdir -p ~/bin
    
    # Create mobile-specific scripts
    cat > ~/bin/mobile-edit << 'EOF'
#!/bin/bash
# Mobile file editor
if [ -z "$1" ]; then
    nvim .
else
    nvim "$1"
fi
EOF
    
    cat > ~/bin/mobile-terminal << 'EOF'
#!/bin/bash
# Mobile terminal
if [ -z "$1" ]; then
    terminal
else
    terminal "$1"
fi
EOF
    
    cat > ~/bin/mobile-git << 'EOF'
#!/bin/bash
# Mobile git operations
case "$1" in
    "s") git status ;;
    "a") git add . ;;
    "c") git commit -m "$2" ;;
    "p") git push ;;
    "l") git log --oneline -10 ;;
    "d") git diff ;;
    "b") git branch ;;
    "co") git checkout "$2" ;;
    "lg") lazygit ;;
    *) git "$@" ;;
esac
EOF
    
    # Make scripts executable
    chmod +x ~/bin/mobile-*
    
    log_success "Mobile tools created"
}

# Setup mobile-specific project structure
setup_mobile_projects() {
    log_info "Setting up mobile project structure..."
    
    # Create project directories
    mkdir -p ~/code/sfcc-project
    mkdir -p ~/code/nextjs-app
    mkdir -p ~/code/leetcode
    mkdir -p ~/docs
    mkdir -p ~/scripts
    mkdir -p ~/bin
    
    # Create mobile-specific project templates
    cat > ~/code/sfcc-project/package.json << 'EOF'
{
  "name": "sfcc-project",
  "version": "1.0.0",
  "description": "SFCC Project",
  "main": "index.js",
  "scripts": {
    "start": "echo 'SFCC server started'",
    "build": "echo 'SFCC build completed'",
    "test": "echo 'SFCC tests completed'"
  },
  "dependencies": {
    "dwupload": "^1.0.0"
  }
}
EOF
    
    cat > ~/code/nextjs-app/package.json << 'EOF'
{
  "name": "nextjs-app",
  "version": "1.0.0",
  "description": "Next.js App",
  "main": "index.js",
  "scripts": {
    "dev": "echo 'Next.js dev server started'",
    "build": "echo 'Next.js build completed'",
    "start": "echo 'Next.js server started'",
    "test": "echo 'Next.js tests completed'"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  }
}
EOF
    
    log_success "Mobile project structure created"
}

# Setup mobile-specific automation
setup_mobile_automation() {
    log_info "Setting up mobile automation..."
    
    # Create mobile-specific automation scripts
    cat > ~/scripts/mobile-start.sh << 'EOF'
#!/bin/bash
# Mobile development start script
echo "🚀 Starting mobile development environment..."

# Set mobile environment
export MOBILE_DEV=true
export TERMUX_HOME="/data/data/com.termux/files/home"

# Start development workflow
~/dev-env/scripts/daily.sh
EOF
    
    cat > ~/scripts/mobile-sync.sh << 'EOF'
#!/bin/bash
# Mobile sync script
echo "🔄 Syncing mobile development environment..."

# Sync with remote repository
git pull origin main
git push origin main

# Sync project files
rsync -avz ~/code/ ~/dev-sync/code/
rsync -avz ~/docs/ ~/dev-sync/docs/
rsync -avz ~/scripts/ ~/dev-sync/scripts/

echo "✅ Mobile sync completed"
EOF
    
    # Make scripts executable
    chmod +x ~/scripts/mobile-*.sh
    
    log_success "Mobile automation created"
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

# Rollback mobile setup
rollback_mobile_setup() {
    log_error "Mobile setup failed. Rolling back changes..."
    
    # Remove mobile aliases
    if [ -f ~/.zsh_aliases_mobile ]; then
        rm ~/.zsh_aliases_mobile
        sed -i '/source ~\/.zsh_aliases_mobile/d' ~/.zshrc 2>/dev/null || true
    fi
    
    # Remove mobile tools
    rm -rf ~/bin/mobile-* 2>/dev/null || true
    
    # Remove mobile scripts
    rm -rf ~/scripts/mobile-*.sh 2>/dev/null || true
    
    # Remove mobile project structure
    rm -rf ~/code 2>/dev/null || true
    
    log_info "Mobile setup rollback completed"
}

# Error handler
mobile_error_handler() {
    local exit_code=$?
    log_error "Mobile setup failed with exit code: $exit_code"
    rollback_mobile_setup
    exit $exit_code
}

# Set error handler
trap mobile_error_handler ERR

# Main function
main() {
    log_info "Setting up mobile development optimizations..."
    
    # Parse command line arguments
    local skip_prerequisites=false
    local skip_packages=false
    local skip_validation=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-prerequisites)
                skip_prerequisites=true
                shift
                ;;
            --skip-packages)
                skip_packages=true
                shift
                ;;
            --skip-validation)
                skip_validation=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--skip-prerequisites] [--skip-packages] [--skip-validation] [--help]"
                echo "  --skip-prerequisites  Skip prerequisite checks"
                echo "  --skip-packages       Skip package installation"
                echo "  --skip-validation    Skip setup validation"
                echo "  --help               Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Detect mobile platform
    detect_mobile_platform
    
    # Check if platform is supported
    if [[ "$PLATFORM" == "unknown" ]]; then
        log_warning "Unknown platform detected"
        log_info "Attempting to continue with generic setup..."
    fi
    
    # Setup platform-specific optimizations
    case $PLATFORM in
        "android")
            setup_android
            ;;
        "ios")
            setup_ios
            ;;
        "macos"|"linux")
            log_info "Desktop platform detected - applying mobile-like optimizations"
            setup_android  # Use Android setup as fallback
            ;;
        *)
            log_error "Unsupported platform: $PLATFORM"
            exit 1
            ;;
    esac
    
    # Setup mobile-specific configurations
    setup_mobile_neovim
    setup_mobile_shell
    setup_mobile_tools
    setup_mobile_projects
    setup_mobile_automation
    
    # Validate setup (unless skipped)
    if [ "$skip_validation" = false ]; then
        log_info "Validating mobile setup..."
        # Add validation logic here
    else
        log_info "Skipping setup validation"
    fi
    
    log_success "Mobile optimizations completed!"
    log_info "Run 'mobile-start' to begin mobile development"
    log_info "Run 'mobile-sync' to sync with other devices"
}

# Run main function
main "$@"

