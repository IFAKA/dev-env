#!/bin/bash

# Next.js Project Script
# Switches to Node.js 18 for Next.js development

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Switch to Node.js 18 for Next.js
switch_to_nextjs() {
    log_info "Switching to Node.js 18 for Next.js development..."
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Switch to Node.js 18
    nvm use 18
    
    # Verify version
    node_version=$(node --version)
    log_success "Using Node.js $node_version for Next.js"
    
    # Set environment variables
    export NODE_VERSION=18
    export PROJECT_TYPE=nextjs
    
    log_success "Next.js environment ready"
}

# Start Next.js development
start_nextjs_dev() {
    log_info "Starting Next.js development..."
    
    # Switch to Next.js Node version
    switch_to_nextjs
    
    # Navigate to Next.js project
    cd ~/code/nextjs-app
    
    # Start development server
    npm run dev
}

# Main function
main() {
    case "${1:-switch}" in
        "switch")
            switch_to_nextjs
            ;;
        "start")
            start_nextjs_dev
            ;;
        *)
            echo "Usage: $0 [switch|start]"
            echo "  switch - Switch to Node.js 18 for Next.js"
            echo "  start  - Start Next.js development"
            ;;
    esac
}

# Run main function
main "$@"
