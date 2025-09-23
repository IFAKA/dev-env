#!/bin/bash

# AI/ML Development Script for Docker
# Runs inside AI development container

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

# Setup AI development environment
setup_ai() {
    log_info "Setting up AI/ML development environment..."
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        log_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Install additional packages if needed
    pip install --upgrade pip
    
    log_success "AI/ML environment ready"
}

# Start Jupyter Lab
start_jupyter() {
    log_info "Starting Jupyter Lab..."
    
    # Setup AI environment
    setup_ai
    
    # Start Jupyter Lab
    jupyter lab --ip=0.0.0.0 --port=8000 --no-browser --allow-root
}

# Start Python REPL
start_python() {
    log_info "Starting Python REPL..."
    
    # Setup AI environment
    setup_ai
    
    # Start Python REPL
    python3
}

# Run AI script
run_ai_script() {
    local script="$1"
    
    if [ -z "$script" ]; then
        log_error "Please provide a script to run"
        exit 1
    fi
    
    log_info "Running AI script: $script"
    
    # Setup AI environment
    setup_ai
    
    # Run script
    python3 "$script"
}

# Install AI packages
install_ai_packages() {
    log_info "Installing AI/ML packages..."
    
    # Setup AI environment
    setup_ai
    
    # Install packages
    pip install \
        openai \
        anthropic \
        langchain \
        transformers \
        datasets \
        accelerate \
        bitsandbytes
    
    log_success "AI packages installed"
}

# Main function
main() {
    case "${1:-setup}" in
        "setup")
            setup_ai
            ;;
        "jupyter")
            start_jupyter
            ;;
        "python")
            start_python
            ;;
        "run")
            run_ai_script "$2"
            ;;
        "install")
            install_ai_packages
            ;;
        *)
            echo "Usage: $0 [COMMAND] [OPTIONS]"
            echo ""
            echo "Commands:"
            echo "  setup     - Setup AI environment"
            echo "  jupyter   - Start Jupyter Lab"
            echo "  python    - Start Python REPL"
            echo "  run       - Run AI script"
            echo "  install   - Install AI packages"
            echo ""
            echo "Examples:"
            echo "  ./ai-dev.sh jupyter"
            echo "  ./ai-dev.sh run script.py"
            echo "  ./ai-dev.sh install"
            ;;
    esac
}

# Run main function
main "$@"
