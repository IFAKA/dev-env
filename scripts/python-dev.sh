#!/bin/bash

# Python Development Script
# For programmers who prefer traditional Python development over Jupyter

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

# Start Python development environment
start_python_dev() {
    log_info "Starting Python development environment..."
    
    # Create Python project structure
    mkdir -p ~/code/python-projects
    cd ~/code/python-projects
    
    # Create virtual environment
    if [ ! -d "venv" ]; then
        python3 -m venv venv
        log_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    source venv/bin/activate
    
    # Install essential packages
    pip install --upgrade pip
    pip install pandas numpy matplotlib seaborn
    pip install jupyter  # For when you need it
    pip install pytest black flake8
    
    log_success "Python development environment ready"
    
    # Start Neovim with Python project
    nvim .
}

# Create Python project
create_python_project() {
    log_info "Creating Python project..."
    
    read -p "Project name: " project_name
    mkdir -p ~/code/python-projects/$project_name
    cd ~/code/python-projects/$project_name
    
    # Create project structure
    mkdir -p src tests docs
    touch src/__init__.py
    touch tests/__init__.py
    touch requirements.txt
    touch README.md
    touch .gitignore
    
    # Create virtual environment
    python3 -m venv venv
    source venv/bin/activate
    
    # Install basic packages
    pip install --upgrade pip
    pip install pytest black flake8
    
    log_success "Python project '$project_name' created"
    
    # Open in Neovim
    nvim .
}

# Run Python file
run_python_file() {
    if [ -z "$1" ]; then
        log_info "Running current Python file..."
        python3 %
    else
        log_info "Running Python file: $1"
        python3 "$1"
    fi
}

# Test Python code
test_python() {
    log_info "Running Python tests..."
    if [ -d "tests" ]; then
        python -m pytest tests/
    else
        log_info "No tests directory found"
    fi
}

# Format Python code
format_python() {
    log_info "Formatting Python code..."
    black .
    flake8 .
    log_success "Python code formatted"
}

# Main function
main() {
    case "${1:-start}" in
        "start")
            start_python_dev
            ;;
        "create")
            create_python_project
            ;;
        "run")
            run_python_file "$2"
            ;;
        "test")
            test_python
            ;;
        "format")
            format_python
            ;;
        *)
            echo "Python Development Script"
            echo ""
            echo "Usage: python-dev [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  start     Start Python development environment"
            echo "  create    Create new Python project"
            echo "  run       Run Python file"
            echo "  test      Run Python tests"
            echo "  format    Format Python code"
            ;;
    esac
}

# Run main function
main "$@"
