#!/bin/bash

# Update Development Environment Script
# Use this when the dev-env repo has been updated

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

# Check if we're in the dev-env directory
check_location() {
    if [ ! -f "setup.sh" ]; then
        log_error "Please run this script from the dev-env directory"
        log_info "cd ~/dev-env && ./scripts/update-env.sh"
        exit 1
    fi
}

# Update the environment
update_environment() {
    log_info "Updating development environment..."
    
    # Pull latest changes
    log_info "Pulling latest changes from repository..."
    git pull origin main
    
    # Check if setup.sh has changed
    if git diff HEAD~1 setup.sh | grep -q "setup.sh"; then
        log_info "Setup script has changed, running setup..."
        ./setup.sh
    else
        log_info "No changes to setup script, skipping setup"
    fi
    
    # Check if configs have changed
    if git diff HEAD~1 configs/ | grep -q "configs/"; then
        log_info "Configurations have changed, updating..."
        ./scripts/sync.sh sync
    else
        log_info "No changes to configurations"
    fi
    
    log_success "Environment updated successfully"
}

# Show current status
show_status() {
    log_info "Current environment status:"
    echo ""
    echo "Repository: $(git remote get-url origin)"
    echo "Branch: $(git branch --show-current)"
    echo "Last commit: $(git log -1 --format='%h %s')"
    echo "Last update: $(git log -1 --format='%ar')"
    echo ""
    
    # Check if there are uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        log_warning "You have uncommitted changes:"
        git status --short
        echo ""
        log_info "To commit your changes:"
        echo "  git add ."
        echo "  git commit -m 'Your message'"
        echo "  git push"
    else
        log_success "Repository is clean"
    fi
}

# Show help
show_help() {
    echo "Update Development Environment Script"
    echo ""
    echo "Usage: update-env [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  update     Update environment from repository"
    echo "  status     Show current status"
    echo "  help       Show this help"
    echo ""
    echo "Examples:"
    echo "  ./scripts/update-env.sh update    # Update environment"
    echo "  ./scripts/update-env.sh status    # Check status"
    echo ""
    echo "This script is for updating the dev-env repository."
    echo "For daily development, use your code projects in ~/code/"
}

# Main function
main() {
    check_location
    
    case "${1:-help}" in
        "update")
            update_environment
            ;;
        "status")
            show_status
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
