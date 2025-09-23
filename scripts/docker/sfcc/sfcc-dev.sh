#!/bin/bash

# SFCC Development Script for Docker
# Runs inside SFCC development container

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

# Switch to Node.js 14 for SFCC
setup_sfcc() {
    log_info "Setting up SFCC development environment..."
    
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
    
    # Setup SFCC environment
    setup_sfcc
    
    # Check if dw.json exists
    if [ ! -f "dw.json" ]; then
        log_info "Creating dw.json template..."
        cat > dw.json << 'EOF'
{
    "hostname": "your-sandbox.demandware.net",
    "username": "your-username",
    "password": "your-app-password",
    "code-version": "version1",
    "cartridge": ["store", "core", "custom_cartridge"]
}
EOF
        log_info "Please edit dw.json with your sandbox credentials"
    fi
    
    # Start development server
    log_info "Starting SFCC development server..."
    npm start
}

# Clean and upload cartridges
sfcc_clean_upload() {
    log_info "Cleaning and uploading SFCC cartridges..."
    
    # Setup SFCC environment
    setup_sfcc
    
    # Check if dwupload is available
    if ! command -v dwupload &> /dev/null; then
        log_error "dwupload not found. Installing..."
        npm install -g dwupload
    fi
    
    # Clean cartridges
    log_info "Cleaning cartridges..."
    find . -name "cartridge" -type d -exec rm -rf {}/static/default/cache/* \; 2>/dev/null || true
    
    # Upload cartridges
    log_info "Uploading cartridges..."
    dwupload --cartridge store:core:custom_cartridge
    
    log_success "SFCC cartridges cleaned and uploaded"
}

# Main function
main() {
    case "${1:-setup}" in
        "setup")
            setup_sfcc
            ;;
        "start")
            start_sfcc_dev
            ;;
        "clean-upload")
            sfcc_clean_upload
            ;;
        *)
            echo "Usage: $0 [setup|start|clean-upload]"
            echo "  setup        - Setup SFCC environment"
            echo "  start        - Start SFCC development"
            echo "  clean-upload - Clean and upload cartridges"
            ;;
    esac
}

# Run main function
main "$@"
