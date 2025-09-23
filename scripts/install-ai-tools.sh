#!/bin/bash

# AI Engineer Tools Installation
# Installs tools for AI/ML development

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

# Install Python tools
install_python_tools() {
    log_info "Installing Python AI/ML tools..."
    
    # Install Python packages
    pip install --upgrade pip
    pip install jupyter notebook
    pip install pandas numpy matplotlib seaborn
    pip install scikit-learn tensorflow torch
    pip install openai anthropic
    pip install langchain llama-index
    pip install streamlit gradio
    pip install fastapi uvicorn
    pip install requests httpx
    
    log_success "Python AI/ML tools installed"
}

# Install trading tools
install_trading_tools() {
    log_info "Installing trading tools..."
    
    # Install trading packages
    pip install yfinance pandas-datareader
    pip install backtrader zipline-reloaded
    pip install ccxt python-binance
    pip install ta-lib talib
    pip install plotly dash
    pip install sqlalchemy psycopg2
    
    log_success "Trading tools installed"
}

# Setup Jupyter notebooks
setup_jupyter() {
    log_info "Setting up Jupyter notebooks..."
    
    # Create Jupyter config
    jupyter notebook --generate-config
    
    # Set up Jupyter extensions
    pip install jupyter_contrib_nbextensions
    jupyter contrib nbextension install --user
    
    log_success "Jupyter notebooks configured"
}

# Main function
main() {
    log_info "Installing AI Engineer tools..."
    
    install_python_tools
    install_trading_tools
    setup_jupyter
    
    log_success "AI Engineer tools installation completed!"
}

# Run main function
main "$@"
