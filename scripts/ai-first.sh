#!/bin/bash

# AI-First Development Workflow
# Optimized for AI-assisted development with Cursor CLI

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

# Start AI-first development
start_ai_first() {
    log_info "Starting AI-first development workflow..."
    
    # Start Cursor CLI
    start_cursor_ai
    
    # Start AI productivity tools
    start_ai_productivity
    
    # Open Neovim with AI integration
    start_ai_neovim
    
    log_success "AI-first development workflow started"
}

# Start Cursor AI
start_cursor_ai() {
    log_info "Starting Cursor AI assistance..."
    
    if command -v cursor &> /dev/null; then
        # Start Cursor in background
        cursor &
        CURSOR_PID=$!
        echo $CURSOR_PID > /tmp/cursor.pid
        
        # Wait for Cursor to start
        sleep 2
        
        log_success "Cursor AI started (PID: $CURSOR_PID)"
        log_info "AI assistance available via Cursor CLI"
    else
        log_error "Cursor not installed. Install with: curl https://cursor.com/install -fsS | bash"
        exit 1
    fi
}

# Start AI productivity tools
start_ai_productivity() {
    log_info "Starting AI productivity tools..."
    
    # Start time tracking
    if command -v timetrap &> /dev/null; then
        timetrap t in "AI Development"
        log_success "Time tracking started"
    fi
    
    # Start task management
    if command -v task &> /dev/null; then
        log_info "Task management available"
        # Add AI development task
        task add "AI-assisted development session" +ai +development
    fi
    
    log_success "AI productivity tools started"
}

# Start Neovim with AI integration
start_ai_neovim() {
    log_info "Starting Neovim with AI integration..."
    
    # Create AI-specific Neovim session
    nvim -c "AIStart" -c "terminal cursor chat" -c "bnext" -c "terminal cursor generate" -c "bnext" -c "terminal cursor debug" -c "bnext" -c "e ~/code/current-project" -c "Buffers"
}

# AI development commands
ai_commands() {
    echo "AI Development Commands:"
    echo ""
    echo "Cursor CLI Commands:"
    echo "  cursor chat              # Start AI chat"
    echo "  cursor generate          # Generate code"
    echo "  cursor debug             # Debug current file"
    echo "  cursor explain           # Explain code"
    echo "  cursor refactor          # Refactor code"
    echo "  cursor test              # Generate tests"
    echo "  cursor optimize          # Optimize code"
    echo ""
    echo "Neovim AI Keymaps:"
    echo "  <leader>ai-chat          # Open AI chat"
    echo "  <leader>ai-gen           # Generate code"
    echo "  <leader>ai-debug         # Debug current file"
    echo "  <leader>cursor           # Open Cursor CLI"
    echo "  <leader>jupyter          # Start Jupyter notebook"
    echo "  <leader>python          # Run Python file"
    echo ""
    echo "Workflow Commands:"
    echo "  ./scripts/ai-first.sh start    # Start AI-first workflow"
    echo "  ./scripts/ai-first.sh status   # Show AI status"
    echo "  ./scripts/ai-first.sh stop     # Stop AI workflow"
}

# Show AI status
show_ai_status() {
    log_info "AI Development Status:"
    
    # Check Cursor AI
    if [ -f /tmp/cursor.pid ]; then
        if ps -p $(cat /tmp/cursor.pid) > /dev/null 2>&1; then
            log_success "Cursor AI running (PID: $(cat /tmp/cursor.pid))"
        else
            log_warning "Cursor AI not running"
        fi
    else
        log_warning "Cursor AI not started"
    fi
    
    # Check time tracking
    if command -v timetrap &> /dev/null; then
        timetrap display
    fi
    
    # Check tasks
    if command -v task &> /dev/null; then
        task list +ai
    fi
}

# Stop AI workflow
stop_ai_workflow() {
    log_info "Stopping AI workflow..."
    
    # Stop Cursor AI
    if [ -f /tmp/cursor.pid ]; then
        kill $(cat /tmp/cursor.pid) 2>/dev/null || true
        rm -f /tmp/cursor.pid
        log_success "Cursor AI stopped"
    fi
    
    # Stop time tracking
    if command -v timetrap &> /dev/null; then
        timetrap t out
        log_success "Time tracking stopped"
    fi
    
    log_success "AI workflow stopped"
}

# AI development session
ai_session() {
    log_info "Starting AI development session..."
    
    # Get project type
    read -p "What type of development? (frontend/ai/trading): " project_type
    
    case $project_type in
        "frontend")
            start_frontend_ai_session
            ;;
        "ai")
            start_ai_ml_session
            ;;
        "trading")
            start_trading_ai_session
            ;;
        *)
            log_error "Invalid project type"
            exit 1
            ;;
    esac
}

# Frontend AI session
start_frontend_ai_session() {
    log_info "Starting frontend AI session..."
    
    # Start Cursor AI
    start_cursor_ai
    
    # Ask for framework
    read -p "Frontend framework? (sfcc/nextjs/vue/angular): " framework
    
    case $framework in
        "sfcc")
            ./scripts/project-sfcc.sh start
            ;;
        "nextjs")
            ./scripts/project-nextjs.sh start
            ;;
        "vue"|"angular")
            start_modern_frontend_ai
            ;;
        *)
            log_error "Invalid framework"
            exit 1
            ;;
    esac
    
    log_success "Frontend AI session started"
}

# AI/ML session
start_ai_ml_session() {
    log_info "Starting AI/ML session..."
    
    # Start Cursor AI
    start_cursor_ai
    
    # Start Jupyter
    jupyter notebook --no-browser --port=8888 &
    JUPYTER_PID=$!
    echo $JUPYTER_PID > /tmp/jupyter.pid
    
    log_success "AI/ML session started"
    log_info "Jupyter: http://localhost:8888"
}

# Trading AI session
start_trading_ai_session() {
    log_info "Starting trading AI session..."
    
    # Start Cursor AI
    start_cursor_ai
    
    # Start trading Jupyter
    jupyter notebook --no-browser --port=8889 &
    JUPYTER_PID=$!
    echo $JUPYTER_PID > /tmp/trading-jupyter.pid
    
    log_success "Trading AI session started"
    log_info "Trading Jupyter: http://localhost:8889"
}

# Main function
main() {
    case "${1:-help}" in
        "start")
            start_ai_first
            ;;
        "session")
            ai_session
            ;;
        "commands")
            ai_commands
            ;;
        "status")
            show_ai_status
            ;;
        "stop")
            stop_ai_workflow
            ;;
        "help"|"-h"|"--help")
            echo "AI-First Development Workflow"
            echo ""
            echo "Usage: ai-first [COMMAND]"
            echo ""
            echo "Commands:"
            echo "  start     Start AI-first workflow"
            echo "  session   Start AI development session"
            echo "  commands  Show AI commands"
            echo "  status    Show AI status"
            echo "  stop      Stop AI workflow"
            echo "  help     Show this help"
            ;;
        *)
            log_error "Unknown command: $1"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
