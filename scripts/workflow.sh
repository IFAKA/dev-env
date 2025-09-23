#!/bin/bash

# Development Workflow Script
# Comprehensive workflow management for all development types

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

# Show help
show_help() {
    echo "Development Workflow Commands"
    echo ""
    echo "Usage: workflow [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  start           Start full development workflow"
    echo "  frontend        Start frontend development (SFCC/Next.js)"
    echo "  ai              Start AI/ML development"
    echo "  trading         Start algorithm trading development"
    echo "  mobile          Start mobile development"
    echo "  sync            Sync across devices"
    echo "  status          Show current status"
    echo "  stop            Stop all development processes"
    echo "  help            Show this help"
    echo ""
    echo "Options:"
    echo "  --no-server     Start without development servers"
    echo "  --ai-only       Start with AI assistance only"
    echo "  --offline       Start in offline mode"
    echo ""
    echo "Examples:"
    echo "  workflow start              # Full development workflow"
    echo "  workflow frontend --no-server  # Frontend without servers"
    echo "  workflow ai --ai-only       # AI development with Cursor"
    echo "  workflow trading --offline  # Trading development offline"
}

# Start full development workflow
start_full_workflow() {
    log_info "Starting full development workflow..."
    
    # Check if running in background mode
    if [[ "$1" == "--no-server" ]]; then
        log_info "Starting without development servers..."
        start_without_servers
    elif [[ "$1" == "--ai-only" ]]; then
        log_info "Starting with AI assistance only..."
        start_ai_workflow
    elif [[ "$1" == "--offline" ]]; then
        log_info "Starting in offline mode..."
        start_offline_workflow
    else
        # Full workflow with servers
        start_development_servers
        start_ai_assistance
        start_productivity_tools
    fi
    
    log_success "Full development workflow started"
}

# Start frontend development
start_frontend_workflow() {
    log_info "Starting frontend development workflow..."
    
    # Ask which frontend framework
    echo "Select frontend framework:"
    echo "1) SFCC (Node.js 14)"
    echo "2) Next.js (Node.js 18)"
    echo "3) Modern Frontend (Vue/Angular/Svelte)"
    read -p "Enter choice (1-3): " choice
    
    case $choice in
        1)
            ./scripts/project-sfcc.sh start
            ;;
        2)
            ./scripts/project-nextjs.sh start
            ;;
        3)
            start_modern_frontend
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    log_success "Frontend development workflow started"
}

# Start AI/ML development
start_ai_workflow() {
    log_info "Starting AI/ML development workflow..."
    
    # Install AI tools if not present
    if ! command -v jupyter &> /dev/null; then
        log_info "Installing AI tools..."
        ./scripts/install-ai-tools.sh
    fi
    
    # Start Jupyter notebook
    log_info "Starting Jupyter notebook..."
    jupyter notebook --no-browser --port=8888 &
    JUPYTER_PID=$!
    echo $JUPYTER_PID > /tmp/jupyter.pid
    
    # Start Cursor AI assistance
    log_info "Starting Cursor AI assistance..."
    cursor &
    CURSOR_PID=$!
    echo $CURSOR_PID > /tmp/cursor.pid
    
    log_success "AI development workflow started"
    log_info "Jupyter: http://localhost:8888"
    log_info "Cursor: AI assistance available"
}

# Start algorithm trading development
start_trading_workflow() {
    log_info "Starting algorithm trading workflow..."
    
    # Check if trading tools are installed
    if ! command -v yfinance &> /dev/null; then
        log_info "Installing trading tools..."
        pip install yfinance pandas-datareader backtrader ccxt ta-lib
    fi
    
    # Start trading development
    log_info "Starting trading development environment..."
    
    # Create trading project if it doesn't exist
    mkdir -p ~/code/trading
    cd ~/code/trading
    
    # Start Jupyter for trading analysis
    jupyter notebook --no-browser --port=8889 &
    JUPYTER_PID=$!
    echo $JUPYTER_PID > /tmp/trading-jupyter.pid
    
    log_success "Trading development workflow started"
    log_info "Trading Jupyter: http://localhost:8889"
}

# Start mobile development
start_mobile_workflow() {
    log_info "Starting mobile development workflow..."
    
    # Run mobile optimizations
    ./scripts/mobile.sh
    
    log_success "Mobile development workflow started"
}

# Start without development servers
start_without_servers() {
    log_info "Starting workflow without development servers..."
    
    # Start productivity tools only
    start_productivity_tools
    start_ai_assistance
    
    log_success "Workflow started without servers"
}

# Start AI assistance only
start_ai_assistance() {
    log_info "Starting AI assistance..."
    
    # Start Cursor CLI
    if command -v cursor &> /dev/null; then
        cursor &
        CURSOR_PID=$!
        echo $CURSOR_PID > /tmp/cursor.pid
        log_success "Cursor AI assistance started"
    else
        log_warning "Cursor not installed"
    fi
}

# Start productivity tools
start_productivity_tools() {
    log_info "Starting productivity tools..."
    
    # Start task management
    if command -v task &> /dev/null; then
        log_info "Task management available"
    fi
    
    # Start time tracking
    if command -v timetrap &> /dev/null; then
        timetrap t in "Development"
        log_success "Time tracking started"
    fi
    
    log_success "Productivity tools started"
}

# Start development servers
start_development_servers() {
    log_info "Starting development servers..."
    
    # Start SFCC server if project exists
    if [ -f ~/code/sfcc-project/package.json ]; then
        log_info "Starting SFCC server..."
        cd ~/code/sfcc-project
        npm start &
        SFCC_PID=$!
        echo $SFCC_PID > /tmp/sfcc.pid
    fi
    
    # Start Next.js server if project exists
    if [ -f ~/code/nextjs-app/package.json ]; then
        log_info "Starting Next.js server..."
        cd ~/code/nextjs-app
        npm run dev &
        NEXTJS_PID=$!
        echo $NEXTJS_PID > /tmp/nextjs.pid
    fi
    
    log_success "Development servers started"
}

# Start offline workflow
start_offline_workflow() {
    log_info "Starting offline workflow..."
    
    # Start productivity tools
    start_productivity_tools
    
    # Start AI assistance (works offline)
    start_ai_assistance
    
    log_success "Offline workflow started"
}

# Show current status
show_status() {
    log_info "Current development status:"
    
    # Check running processes
    if [ -f /tmp/sfcc.pid ]; then
        if ps -p $(cat /tmp/sfcc.pid) > /dev/null 2>&1; then
            log_success "SFCC server running (PID: $(cat /tmp/sfcc.pid))"
        else
            log_warning "SFCC server not running"
        fi
    fi
    
    if [ -f /tmp/nextjs.pid ]; then
        if ps -p $(cat /tmp/nextjs.pid) > /dev/null 2>&1; then
            log_success "Next.js server running (PID: $(cat /tmp/nextjs.pid))"
        else
            log_warning "Next.js server not running"
        fi
    fi
    
    if [ -f /tmp/cursor.pid ]; then
        if ps -p $(cat /tmp/cursor.pid) > /dev/null 2>&1; then
            log_success "Cursor AI running (PID: $(cat /tmp/cursor.pid))"
        else
            log_warning "Cursor AI not running"
        fi
    fi
    
    if [ -f /tmp/jupyter.pid ]; then
        if ps -p $(cat /tmp/jupyter.pid) > /dev/null 2>&1; then
            log_success "Jupyter running (PID: $(cat /tmp/jupyter.pid))"
        else
            log_warning "Jupyter not running"
        fi
    fi
}

# Stop all development processes
stop_workflow() {
    log_info "Stopping all development processes..."
    
    # Stop servers
    [ -f /tmp/sfcc.pid ] && kill $(cat /tmp/sfcc.pid) 2>/dev/null || true
    [ -f /tmp/nextjs.pid ] && kill $(cat /tmp/nextjs.pid) 2>/dev/null || true
    [ -f /tmp/cursor.pid ] && kill $(cat /tmp/cursor.pid) 2>/dev/null || true
    [ -f /tmp/jupyter.pid ] && kill $(cat /tmp/jupyter.pid) 2>/dev/null || true
    [ -f /tmp/trading-jupyter.pid ] && kill $(cat /tmp/trading-jupyter.pid) 2>/dev/null || true
    
    # Clean up PID files
    rm -f /tmp/sfcc.pid /tmp/nextjs.pid /tmp/cursor.pid /tmp/jupyter.pid /tmp/trading-jupyter.pid
    
    # Stop time tracking
    if command -v timetrap &> /dev/null; then
        timetrap t out
    fi
    
    log_success "All development processes stopped"
}

# Main function
main() {
    case "${1:-help}" in
        "start")
            start_full_workflow "$2"
            ;;
        "frontend")
            start_frontend_workflow
            ;;
        "ai")
            start_ai_workflow
            ;;
        "trading")
            start_trading_workflow
            ;;
        "mobile")
            start_mobile_workflow
            ;;
        "sync")
            ./scripts/sync.sh sync
            ;;
        "status")
            show_status
            ;;
        "stop")
            stop_workflow
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
