#!/bin/bash

# Start Development Environment
# Quick start script for daily development workflow

set -e

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

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if we're in the right directory
check_environment() {
    if [ ! -f "setup.sh" ]; then
        log_warning "Not in dev-env directory. Changing to dev-env directory..."
        cd ~/dev-env 2>/dev/null || {
            log_error "dev-env directory not found. Please run from the correct location."
            exit 1
        }
    fi
}

# Start development workflow
start_development() {
    log_info "Starting development environment..."
    
    # Check if Neovim is available
    if ! command -v nvim &> /dev/null; then
        log_warning "Neovim not found. Please run setup.sh first."
        exit 1
    fi
    
    # Check if we're in a project directory
    if [ -f "package.json" ] || [ -f "dw.json" ] || [ -f "requirements.txt" ]; then
        log_info "Project detected. Starting development..."
        
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
            # SFCC development doesn't need a server
        elif [ -f "requirements.txt" ]; then
            log_info "Python project detected"
            log_info "Starting Python development..."
            # Python development setup
        fi
        
        # Open Neovim
        log_info "Opening Neovim..."
        nvim .
    else
        log_info "No project detected. Opening Neovim in current directory..."
        nvim .
    fi
}

# Main function
main() {
    check_environment
    start_development
    
    log_success "Development environment started!"
    log_info "Use Ctrl+C to stop any running servers"
}

# Run main function
main "$@"
