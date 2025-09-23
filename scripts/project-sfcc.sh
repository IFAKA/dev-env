#!/bin/bash

# SFCC Project Script
# Switches to Node.js 14 for SFCC development

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Switch to Node.js 14 for SFCC
switch_to_sfcc() {
    log_info "Switching to Node.js 14 for SFCC development..."
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Switch to Node.js 14
    nvm use 14
    
    # Verify version
    node_version=$(node --version)
    log_success "Using Node.js $node_version for SFCC"
    
    # Set environment variables
    export NODE_VERSION=14
    export PROJECT_TYPE=sfcc
    
    log_success "SFCC environment ready"
}

# Start SFCC development
start_sfcc_dev() {
    log_info "Starting SFCC development..."
    
    # Switch to SFCC Node version
    switch_to_sfcc
    
    # Navigate to SFCC project
    cd ~/code/sfcc-project
    
    # Start development server
    npm start
}

# Clean and upload all cartridges (Prophet-like functionality)
clean_upload_all() {
    log_info "Starting SFCC Clean and Upload (Prophet-like)..."
    
    # Use the Prophet script
    if [ -f "../scripts/sfcc-prophet.sh" ]; then
        ../scripts/sfcc-prophet.sh clean-upload
    else
        log_error "sfcc-prophet.sh not found. Please run from dev-env directory"
        exit 1
    fi
}

# Clean cartridges only
clean_cartridges() {
    log_info "Cleaning SFCC cartridges..."
    
    if [ -f "../scripts/sfcc-prophet.sh" ]; then
        ../scripts/sfcc-prophet.sh clean
    else
        log_error "sfcc-prophet.sh not found. Please run from dev-env directory"
        exit 1
    fi
}

# Upload cartridges only
upload_cartridges() {
    log_info "Uploading SFCC cartridges..."
    
    if [ -f "../scripts/sfcc-prophet.sh" ]; then
        ../scripts/sfcc-prophet.sh upload
    else
        log_error "sfcc-prophet.sh not found. Please run from dev-env directory"
        exit 1
    fi
}

# Show SFCC status
show_status() {
    log_info "SFCC Project Status:"
    
    if [ -f "../scripts/sfcc-prophet.sh" ]; then
        ../scripts/sfcc-prophet.sh status
    else
        log_error "sfcc-prophet.sh not found. Please run from dev-env directory"
        exit 1
    fi
}

# Main function
main() {
    case "${1:-switch}" in
        "switch")
            switch_to_sfcc
            ;;
        "start")
            start_sfcc_dev
            ;;
        "clean-upload")
            clean_upload_all
            ;;
        "clean")
            clean_cartridges
            ;;
        "upload")
            upload_cartridges
            ;;
        "status")
            show_status
            ;;
        *)
            echo "Usage: $0 [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  switch        - Switch to Node.js 14 for SFCC"
            echo "  start         - Start SFCC development"
            echo "  clean-upload  - Clean and upload all cartridges (Prophet-like)"
            echo "  clean         - Clean cartridges only"
            echo "  upload        - Upload cartridges only"
            echo "  status        - Show project status"
            echo ""
            echo "Neovim Keymaps:"
            echo "  <leader>sfcc-all     # Clean and upload all"
            echo "  <leader>sfcc-clean   # Clean cartridges"
            echo "  <leader>sfcc-upload  # Upload cartridges"
            echo "  <leader>sfcc-status # Show status"
            ;;
    esac
}

# Run main function
main "$@"
