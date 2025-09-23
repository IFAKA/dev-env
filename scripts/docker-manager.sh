#!/bin/bash

# Docker Environment Manager
# Manages insulated development environments for building and testing

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

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        log_info "Install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        log_info "Install Docker Compose: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    log_success "Docker and Docker Compose are available"
}

# Build all environments
build_all() {
    log_info "Building all development environments..."
    
    cd docker
    
    # Build main environment
    log_info "Building main development environment..."
    docker build -t universal-dev-env .
    
    # Build SFCC environment
    log_info "Building SFCC development environment..."
    docker build -f Dockerfile.sfcc -t sfcc-dev-env .
    
    # Build AI environment
    log_info "Building AI/ML development environment..."
    docker build -f Dockerfile.ai -t ai-dev-env .
    
    # Build data visualization environment
    log_info "Building data visualization environment..."
    docker build -f Dockerfile.data -t data-viz-env .
    
    cd ..
    
    log_success "All environments built successfully"
}

# Start development environment
start_dev() {
    log_info "Starting development environment..."
    
    cd docker
    docker-compose up -d dev-env
    cd ..
    
    log_success "Development environment started"
    log_info "Access with: docker exec -it universal-dev-env bash"
}

# Start SFCC environment
start_sfcc() {
    log_info "Starting SFCC development environment..."
    
    cd docker
    docker-compose up -d sfcc-dev
    cd ..
    
    log_success "SFCC development environment started"
    log_info "Access with: docker exec -it sfcc-dev-env bash"
}

# Start AI environment
start_ai() {
    log_info "Starting AI/ML development environment..."
    
    cd docker
    docker-compose up -d ai-dev
    cd ..
    
    log_success "AI/ML development environment started"
    log_info "Access with: docker exec -it ai-dev-env bash"
    log_info "Jupyter Lab: http://localhost:8000"
}

# Start data visualization environment
start_data() {
    log_info "Starting data visualization environment..."
    
    cd docker
    docker-compose up -d data-viz
    cd ..
    
    log_success "Data visualization environment started"
    log_info "Access with: docker exec -it data-viz-env bash"
    log_info "Jupyter Lab: http://localhost:8000"
}

# Stop all environments
stop_all() {
    log_info "Stopping all development environments..."
    
    cd docker
    docker-compose down
    cd ..
    
    log_success "All environments stopped"
}

# Clean up environments
cleanup() {
    log_info "Cleaning up Docker environments..."
    
    # Stop all containers
    docker-compose -f docker/docker-compose.yml down
    
    # Remove containers
    docker container prune -f
    
    # Remove images
    docker image prune -f
    
    # Remove volumes
    docker volume prune -f
    
    log_success "Docker cleanup completed"
}

# Show environment status
status() {
    log_info "Docker environment status:"
    echo ""
    
    # Show running containers
    echo "Running containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    
    # Show available images
    echo "Available images:"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
    echo ""
    
    # Show disk usage
    echo "Docker disk usage:"
    docker system df
}

# Execute command in environment
exec_cmd() {
    local env_type="$1"
    local command="$2"
    
    case "$env_type" in
        "dev")
            docker exec -it universal-dev-env bash -c "$command"
            ;;
        "sfcc")
            docker exec -it sfcc-dev-env bash -c "$command"
            ;;
        "ai")
            docker exec -it ai-dev-env bash -c "$command"
            ;;
        "data")
            docker exec -it data-viz-env bash -c "$command"
            ;;
        *)
            log_error "Unknown environment: $env_type"
            exit 1
            ;;
    esac
}

# Show help
show_help() {
    echo "Docker Environment Manager"
    echo ""
    echo "Usage: docker-manager [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build           Build all environments"
    echo "  start-dev       Start main development environment"
    echo "  start-sfcc      Start SFCC development environment"
    echo "  start-ai        Start AI/ML development environment"
    echo "  start-data      Start data visualization environment"
    echo "  stop            Stop all environments"
    echo "  cleanup         Clean up Docker resources"
    echo "  status          Show environment status"
    echo "  exec            Execute command in environment"
    echo "  help           Show this help"
    echo ""
    echo "Examples:"
    echo "  ./scripts/docker-manager.sh build"
    echo "  ./scripts/docker-manager.sh start-ai"
    echo "  ./scripts/docker-manager.sh exec ai 'jupyter lab --ip=0.0.0.0 --port=8000'"
    echo "  ./scripts/docker-manager.sh status"
    echo ""
    echo "Environment Types:"
    echo "  dev    - Main development environment"
    echo "  sfcc   - SFCC development environment"
    echo "  ai     - AI/ML development environment"
    echo "  data   - Data visualization environment"
}

# Main function
main() {
    check_docker
    
    case "${1:-help}" in
        "build")
            build_all
            ;;
        "start-dev")
            start_dev
            ;;
        "start-sfcc")
            start_sfcc
            ;;
        "start-ai")
            start_ai
            ;;
        "start-data")
            start_data
            ;;
        "stop")
            stop_all
            ;;
        "cleanup")
            cleanup
            ;;
        "status")
            status
            ;;
        "exec")
            exec_cmd "$2" "$3"
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
