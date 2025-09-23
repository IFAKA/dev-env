#!/bin/bash

# Data Visualization Development Script for Docker
# Runs inside data visualization container

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

# Setup data visualization environment
setup_data() {
    log_info "Setting up data visualization environment..."
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        log_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Install additional packages if needed
    pip install --upgrade pip
    
    log_success "Data visualization environment ready"
}

# Start Jupyter Lab
start_jupyter() {
    log_info "Starting Jupyter Lab..."
    
    # Setup data environment
    setup_data
    
    # Start Jupyter Lab
    jupyter lab --ip=0.0.0.0 --port=8000 --no-browser --allow-root
}

# Start Streamlit app
start_streamlit() {
    local app="$1"
    
    if [ -z "$app" ]; then
        log_error "Please provide a Streamlit app to run"
        exit 1
    fi
    
    log_info "Starting Streamlit app: $app"
    
    # Setup data environment
    setup_data
    
    # Start Streamlit
    streamlit run "$app" --server.port 5000 --server.address 0.0.0.0
}

# Start Python REPL
start_python() {
    log_info "Starting Python REPL..."
    
    # Setup data environment
    setup_ai
    
    # Start Python REPL
    python3
}

# Run data analysis
run_analysis() {
    local script="$1"
    
    if [ -z "$script" ]; then
        log_error "Please provide a script to run"
        exit 1
    fi
    
    log_info "Running data analysis: $script"
    
    # Setup data environment
    setup_data
    
    # Run script
    python3 "$script"
}

# Install data packages
install_data_packages() {
    log_info "Installing data visualization packages..."
    
    # Setup data environment
    setup_data
    
    # Install packages
    pip install \
        yfinance \
        pandas-datareader \
        ccxt \
        ta-lib \
        backtrader \
        zipline \
        streamlit \
        dash \
        plotly-dash
    
    log_success "Data packages installed"
}

# Main function
main() {
    case "${1:-setup}" in
        "setup")
            setup_data
            ;;
        "jupyter")
            start_jupyter
            ;;
        "streamlit")
            start_streamlit "$2"
            ;;
        "python")
            start_python
            ;;
        "run")
            run_analysis "$2"
            ;;
        "install")
            install_data_packages
            ;;
        *)
            echo "Usage: $0 [COMMAND] [OPTIONS]"
            echo ""
            echo "Commands:"
            echo "  setup      - Setup data environment"
            echo "  jupyter    - Start Jupyter Lab"
            echo "  streamlit  - Start Streamlit app"
            echo "  python     - Start Python REPL"
            echo "  run        - Run data analysis script"
            echo "  install    - Install data packages"
            echo ""
            echo "Examples:"
            echo "  ./data-dev.sh jupyter"
            echo "  ./data-dev.sh streamlit app.py"
            echo "  ./data-dev.sh run analysis.py"
            echo "  ./data-dev.sh install"
            ;;
    esac
}

# Run main function
main "$@"
