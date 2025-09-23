#!/bin/bash

# Project Manager Script
# Handles GitHub/GitLab project operations

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
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

# Project directory - use current working directory or fallback to ~/code
# Get the directory where the script is being called from
if [ -n "$NVIM_CWD" ]; then
    PROJECT_DIR="$NVIM_CWD"
elif [ -n "$PWD" ]; then
    PROJECT_DIR="$PWD"
else
    PROJECT_DIR="$HOME/code"
fi

# Debug information
echo "DEBUG: PROJECT_DIR is set to: $PROJECT_DIR" >&2

# List GitHub projects
list_github_projects() {
    log_info "Listing GitHub projects..."
    
    if [ ! -d "$PROJECT_DIR" ]; then
        log_error "Code directory not found: $PROJECT_DIR"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    # Find all Git repositories
    local projects=()
    while IFS= read -r -d '' repo; do
        # Get repository name
        local repo_name=$(basename "$repo")
        local repo_path=$(dirname "$repo")
        
        # Check if it's a GitHub repository
        if git -C "$repo" remote get-url origin 2>/dev/null | grep -q "github.com"; then
            projects+=("$repo_name:$repo_path")
        fi
    done < <(find . -name ".git" -type d -print0 2>/dev/null)
    
    if [ ${#projects[@]} -eq 0 ]; then
        log_warning "No GitHub projects found"
        return 1
    fi
    
    # Display projects
    log_info "GitHub projects found:"
    for project in "${projects[@]}"; do
        echo "  • $project"
    done
    
    return 0
}

# List GitLab projects
list_gitlab_projects() {
    log_info "Listing GitLab projects..."
    
    if [ ! -d "$PROJECT_DIR" ]; then
        log_error "Code directory not found: $PROJECT_DIR"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    # Find all Git repositories
    local projects=()
    while IFS= read -r -d '' repo; do
        # Get repository name
        local repo_name=$(basename "$repo")
        local repo_path=$(dirname "$repo")
        
        # Check if it's a GitLab repository
        if git -C "$repo" remote get-url origin 2>/dev/null | grep -q "gitlab.com"; then
            projects+=("$repo_name:$repo_path")
        fi
    done < <(find . -name ".git" -type d -print0 2>/dev/null)
    
    if [ ${#projects[@]} -eq 0 ]; then
        log_warning "No GitLab projects found"
        return 1
    fi
    
    # Display projects
    log_info "GitLab projects found:"
    for project in "${projects[@]}"; do
        echo "  • $project"
    done
    
    return 0
}

# Create new GitHub project
create_github_project() {
    local project_name="$1"
    
    if [ -z "$project_name" ]; then
        log_error "Project name is required"
        return 1
    fi
    
    log_info "Creating new GitHub project: $project_name"
    
    # Create project directory
    local project_path="$PROJECT_DIR/$project_name"
    
    if [ -d "$project_path" ]; then
        log_error "Project already exists: $project_path"
        return 1
    fi
    
    mkdir -p "$project_path"
    cd "$project_path"
    
    # Initialize Git repository
    git init
    git branch -M main
    
    # Create initial files
    echo "# $project_name" > README.md
    echo "node_modules/" > .gitignore
    echo "*.log" >> .gitignore
    echo ".env" >> .gitignore
    
    # Initial commit
    git add .
    git commit -m "Initial commit"
    
    log_success "GitHub project created: $project_path"
    log_info "Next steps:"
    log_info "1. Create repository on GitHub"
    log_info "2. Add remote: git remote add origin https://github.com/USERNAME/$project_name.git"
    log_info "3. Push: git push -u origin main"
    
    return 0
}

# Open project with fzf
open_project() {
    log_info "Opening project..."
    
    if [ ! -d "$PROJECT_DIR" ]; then
        log_error "Code directory not found: $PROJECT_DIR"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    # Find all Git repositories and let user select
    local selected_project
    selected_project=$(find . -name ".git" -type d | sed 's|/.git||' | sed 's|^./||' | fzf --prompt="Select project: " --height=40% --reverse)
    
    if [ -z "$selected_project" ]; then
        log_warning "No project selected"
        return 1
    fi
    
    log_success "Opening project: $selected_project"
    
    # Open in Neovim
    nvim "$PROJECT_DIR/$selected_project"
    
    return 0
}

# Main function
main() {
    case "${1:-help}" in
        "list-github")
            list_github_projects
            ;;
        "list-gitlab")
            list_gitlab_projects
            ;;
        "create")
            create_github_project "$2"
            ;;
        "open")
            open_project
            ;;
        "help"|*)
            echo "Usage: $0 [COMMAND] [OPTIONS]"
            echo ""
            echo "Commands:"
            echo "  list-github    List GitHub projects"
            echo "  list-gitlab    List GitLab projects"
            echo "  create NAME    Create new GitHub project"
            echo "  open           Open project with fzf"
            echo "  help           Show this help"
            echo ""
            echo "Examples:"
            echo "  $0 list-github"
            echo "  $0 create my-new-project"
            echo "  $0 open"
            ;;
    esac
}

# Run main function
main "$@"
