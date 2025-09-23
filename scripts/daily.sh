#!/bin/bash

# Daily Development Workflow Script
# Automates your entire development day

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

# Check if running on mobile device
is_mobile() {
    if [[ "$OSTYPE" == "android"* ]] || [[ -f /data/data/com.termux/files/usr/bin/termux-info ]] || [[ -f /etc/alpine-release ]]; then
        return 0
    else
        return 1
    fi
}

# Block distracting sites (desktop only)
block_distractions() {
    if ! is_mobile; then
        log_info "Blocking distracting sites..."
        
        # Backup original hosts file
        sudo cp /etc/hosts /etc/hosts.backup
        
        # Add blocking entries
        sudo tee -a /etc/hosts > /dev/null << EOF
# Distraction blocking
127.0.0.1 pornhub.com xvideos.com onlyfans.com
127.0.0.1 tiktok.com twitch.tv 9gag.com buzzfeed.com
127.0.0.1 dailymail.co.uk tmz.com instagram.com
127.0.0.1 youtube.com reddit.com facebook.com
127.0.0.1 twitter.com x.com linkedin.com
127.0.0.1 netflix.com hulu.com disney.com
127.0.0.1 amazon.com ebay.com shopify.com
127.0.0.1 news.google.com cnn.com bbc.com
EOF
        
        # Flush DNS cache
        if command -v dscacheutil &> /dev/null; then
            sudo dscacheutil -flushcache
        fi
        
        log_success "Distracting sites blocked"
    else
        log_info "Skipping site blocking on mobile device"
    fi
}

# Start development servers
start_servers() {
    log_info "Starting development servers..."
    
    # Create project directories if they don't exist
    mkdir -p ~/code/sfcc-project
    mkdir -p ~/code/nextjs-app
    mkdir -p ~/code/leetcode
    
    # Start SFCC server (if project exists)
    if [ -f ~/code/sfcc-project/package.json ]; then
        log_info "Starting SFCC server..."
        cd ~/code/sfcc-project
        if [ -f package.json ]; then
            npm start &
            SFCC_PID=$!
            echo $SFCC_PID > /tmp/sfcc.pid
        fi
    fi
    
    # Start Next.js server (if project exists)
    if [ -f ~/code/nextjs-app/package.json ]; then
        log_info "Starting Next.js server..."
        cd ~/code/nextjs-app
        if [ -f package.json ]; then
            npm run dev &
            NEXTJS_PID=$!
            echo $NEXTJS_PID > /tmp/nextjs.pid
        fi
    fi
    
    log_success "Development servers started"
}

# Open Neovim with automated setup
open_neovim() {
    log_info "Opening Neovim with automated setup..."
    
    # Create a temporary script for Neovim commands
    cat > /tmp/nvim_setup.vim << 'EOF'
" Automated Neovim setup
set number
syntax on

" Open terminal buffers
terminal
bnext
terminal
bnext
terminal
bnext

" Open project files
e ~/code/sfcc-project/cartridge/controllers/Home.js
bnext
e ~/code/nextjs-app/app/page.tsx
bnext

" Show buffers
Buffers
EOF
    
    # Open Neovim with the setup script
    nvim -c "source /tmp/nvim_setup.vim"
    
    # Clean up
    rm -f /tmp/nvim_setup.vim
}

# Check tasks and emails
check_tasks() {
    log_info "Checking tasks and emails..."
    
    # Check tasks
    if command -v task &> /dev/null; then
        log_info "Current tasks:"
        task list
    fi
    
    # Check emails (if configured)
    if command -v neomutt &> /dev/null; then
        log_info "Checking emails..."
        neomutt -f imaps://imap.gmail.com/INBOX
    fi
    
    log_success "Tasks and emails checked"
}

# Start pomodoro timer
start_pomodoro() {
    log_info "Starting pomodoro timer..."
    
    if command -v timetrap &> /dev/null; then
        timetrap t in "Development"
        log_success "Pomodoro timer started"
    else
        log_warning "Timetrap not installed, skipping pomodoro timer"
    fi
}

# Setup mobile optimizations
setup_mobile() {
    if is_mobile; then
        log_info "Setting up mobile optimizations..."
        
        # Set mobile-specific environment variables
        export MOBILE_DEV=true
        export TERMUX_HOME="/data/data/com.termux/files/home"
        
        # Create mobile-specific aliases
        alias ll='ls -la'
        alias la='ls -A'
        alias l='ls -CF'
        
        # Set touch-friendly keymaps
        if command -v nvim &> /dev/null; then
            nvim -c "set mouse=a" -c "set number" -c "set relativenumber"
        fi
        
        log_success "Mobile optimizations applied"
    fi
}

# Cleanup function
cleanup() {
    log_info "Cleaning up..."
    
    # Stop servers
    if [ -f /tmp/sfcc.pid ]; then
        kill $(cat /tmp/sfcc.pid) 2>/dev/null || true
        rm -f /tmp/sfcc.pid
    fi
    
    if [ -f /tmp/nextjs.pid ]; then
        kill $(cat /tmp/nextjs.pid) 2>/dev/null || true
        rm -f /tmp/nextjs.pid
    fi
    
    # Stop timetrap
    if command -v timetrap &> /dev/null; then
        timetrap t out
    fi
    
    log_success "Cleanup completed"
}

# Main function
main() {
    log_info "Starting daily development workflow..."
    
    # Setup signal handlers
    trap cleanup EXIT INT TERM
    
    # Run setup steps
    block_distractions
    start_servers
    setup_mobile
    start_pomodoro
    check_tasks
    
    # Open Neovim (this will block until Neovim exits)
    open_neovim
    
    log_success "Daily workflow completed"
}

# Run main function
main "$@"

