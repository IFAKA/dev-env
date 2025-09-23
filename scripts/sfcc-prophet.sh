#!/bin/bash

# SFCC Prophet-like functionality for Neovim
# Equivalent to VS Code Prophet extension's "Clean Project/Upload all" feature

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in an SFCC project
check_sfcc_project() {
    if [ ! -f "dw.json" ] && [ ! -f "dw.js" ]; then
        log_error "No dw.json or dw.js found. Are you in an SFCC project?"
        log_info "Create dw.json with your sandbox credentials:"
        cat << 'EOF'
{
    "hostname": "your-sandbox.demandware.net",
    "username": "your-username",
    "password": "your-app-password",
    "code-version": "version1"
}
EOF
        exit 1
    fi
}

# Get SFCC configuration
get_sfcc_config() {
    if [ -f "dw.json" ]; then
        HOSTNAME=$(grep -o '"hostname": "[^"]*"' dw.json | cut -d'"' -f4)
        USERNAME=$(grep -o '"username": "[^"]*"' dw.json | cut -d'"' -f4)
        PASSWORD=$(grep -o '"password": "[^"]*"' dw.json | cut -d'"' -f4)
        CODE_VERSION=$(grep -o '"code-version": "[^"]*"' dw.json | cut -d'"' -f4)
    elif [ -f "dw.js" ]; then
        # Parse dw.js (JavaScript config)
        HOSTNAME=$(node -e "const config = require('./dw.js'); console.log(config.hostname);")
        USERNAME=$(node -e "const config = require('./dw.js'); console.log(config.username);")
        PASSWORD=$(node -e "const config = require('./dw.js'); console.log(config.password);")
        CODE_VERSION=$(node -e "const config = require('./dw.js'); console.log(config.codeVersion);")
    fi
    
    if [ -z "$HOSTNAME" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$CODE_VERSION" ]; then
        log_error "Invalid dw.json or dw.js configuration"
        exit 1
    fi
    
    log_info "Using sandbox: $HOSTNAME"
    log_info "Code version: $CODE_VERSION"
}

# Clean all cartridges
clean_cartridges() {
    log_info "Cleaning all cartridges..."
    
    # Find all cartridge directories
    CARTRIDGES=$(find . -name "cartridge" -type d | head -10)
    
    if [ -z "$CARTRIDGES" ]; then
        log_warning "No cartridge directories found"
        return 0
    fi
    
    # Clean each cartridge
    for cartridge in $CARTRIDGES; do
        log_info "Cleaning cartridge: $cartridge"
        
        # Clean static cache
        if [ -d "$cartridge/static/default/cache" ]; then
            rm -rf "$cartridge/static/default/cache"/*
            log_success "Cleaned static cache in $cartridge"
        fi
        
        # Clean other cache directories
        find "$cartridge" -name "cache" -type d -exec rm -rf {}/* \; 2>/dev/null || true
    done
    
    log_success "All cartridges cleaned"
}

# Upload all cartridges
upload_cartridges() {
    log_info "Uploading all cartridges to sandbox..."
    
    # Get cartridge list from dw.json or find all cartridges
    if [ -f "dw.json" ]; then
        CARTRIDGE_LIST=$(grep -o '"cartridge": \[[^]]*\]' dw.json | sed 's/"cartridge": \[//' | sed 's/\]//' | tr -d '"' | tr ',' ' ')
    fi
    
    if [ -z "$CARTRIDGE_LIST" ]; then
        # Auto-detect cartridges
        CARTRIDGE_LIST=$(find . -name "cartridge" -type d | sed 's|./||' | sed 's|/cartridge||' | head -10)
    fi
    
    if [ -z "$CARTRIDGE_LIST" ]; then
        log_error "No cartridges found to upload"
        exit 1
    fi
    
    log_info "Uploading cartridges: $CARTRIDGE_LIST"
    
    # Upload each cartridge
    for cartridge in $CARTRIDGE_LIST; do
        if [ -d "$cartridge/cartridge" ]; then
            log_info "Uploading cartridge: $cartridge"
            dwupload --hostname "$HOSTNAME" --username "$USERNAME" --password "$PASSWORD" --code-version "$CODE_VERSION" --cartridge "$cartridge"
            log_success "Uploaded cartridge: $cartridge"
        else
            log_warning "Cartridge directory not found: $cartridge"
        fi
    done
    
    log_success "All cartridges uploaded to $HOSTNAME"
}

# Clean and upload all cartridges (main function)
clean_and_upload() {
    log_info "Starting SFCC Clean and Upload process..."
    
    # Check prerequisites
    check_sfcc_project
    get_sfcc_config
    
    # Check if dwupload is available
    if ! command -v dwupload &> /dev/null; then
        log_error "dwupload not found. Install it with: npm install -g dwupload"
        exit 1
    fi
    
    # Clean cartridges
    clean_cartridges
    
    # Upload cartridges
    upload_cartridges
    
    log_success "SFCC Clean and Upload completed successfully!"
    log_info "All cartridges have been cleaned and uploaded to $HOSTNAME"
}

# Show status
show_status() {
    log_info "SFCC Project Status:"
    echo ""
    
    if [ -f "dw.json" ]; then
        echo "Configuration: dw.json"
        HOSTNAME=$(grep -o '"hostname": "[^"]*"' dw.json | cut -d'"' -f4)
        CODE_VERSION=$(grep -o '"code-version": "[^"]*"' dw.json | cut -d'"' -f4)
        echo "Sandbox: $HOSTNAME"
        echo "Code Version: $CODE_VERSION"
    elif [ -f "dw.js" ]; then
        echo "Configuration: dw.js"
        HOSTNAME=$(node -e "const config = require('./dw.js'); console.log(config.hostname);")
        CODE_VERSION=$(node -e "const config = require('./dw.js'); console.log(config.codeVersion);")
        echo "Sandbox: $HOSTNAME"
        echo "Code Version: $CODE_VERSION"
    else
        echo "No configuration found"
    fi
    
    echo ""
    echo "Cartridges found:"
    find . -name "cartridge" -type d | head -10 | while read -r cartridge; do
        echo "  - $cartridge"
    done
    
    echo ""
    echo "dwupload available: $(command -v dwupload &> /dev/null && echo "Yes" || echo "No")"
}

# Create dw.json template
create_config() {
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
    
    log_success "dw.json template created"
    log_info "Edit dw.json with your sandbox credentials"
}

# Show help
show_help() {
    echo "SFCC Prophet-like functionality for Neovim"
    echo ""
    echo "Usage: sfcc-prophet [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  clean-upload    Clean and upload all cartridges (main function)"
    echo "  clean           Clean all cartridges only"
    echo "  upload          Upload all cartridges only"
    echo "  status          Show project status"
    echo "  config          Create dw.json template"
    echo "  help           Show this help"
    echo ""
    echo "Examples:"
    echo "  ./scripts/sfcc-prophet.sh clean-upload    # Clean and upload all"
    echo "  ./scripts/sfcc-prophet.sh status          # Check status"
    echo "  ./scripts/sfcc-prophet.sh config         # Create config template"
    echo ""
    echo "This script provides the same functionality as VS Code Prophet extension's"
    echo "'Clean Project/Upload all' feature, but for Neovim."
}

# Main function
main() {
    case "${1:-help}" in
        "clean-upload")
            clean_and_upload
            ;;
        "clean")
            check_sfcc_project
            get_sfcc_config
            clean_cartridges
            ;;
        "upload")
            check_sfcc_project
            get_sfcc_config
            upload_cartridges
            ;;
        "status")
            show_status
            ;;
        "config")
            create_config
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
