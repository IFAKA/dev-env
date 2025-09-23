#!/bin/bash

# Project Dashboard - TUI for GitHub/GitLab project management
# Similar to initial dashboard but focused on project operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Default project directory
PROJECT_DIR="/Users/faka/Documents/Projects/Code"

# GitHub/GitLab CLI tools
GITHUB_CLI="gh"
GITLAB_CLI="glab"

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if CLI tools are available
check_cli_tools() {
    local missing_tools=()
    
    if ! command -v "$GITHUB_CLI" &> /dev/null; then
        missing_tools+=("gh (GitHub CLI)")
    fi
    
    if ! command -v "$GITLAB_CLI" &> /dev/null; then
        missing_tools+=("glab (GitLab CLI)")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_warning "Missing CLI tools:"
        for tool in "${missing_tools[@]}"; do
            echo "  - $tool"
        done
        echo ""
        log_info "Install missing tools:"
        echo "  GitHub CLI: brew install gh"
        echo "  GitLab CLI: brew install glab"
        echo ""
        return 1
    fi
    
    return 0
}

# Check if repository exists locally
check_local_repo() {
    local repo_name="$1"
    local repo_path="$PROJECT_DIR/$repo_name"
    
    if [ -d "$repo_path" ] && [ -d "$repo_path/.git" ]; then
        return 0  # Repository exists
    else
        return 1  # Repository doesn't exist
    fi
}

# Clone repository from GitHub
clone_github_repo() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    local repo_path="$PROJECT_DIR/$repo_name"
    
    log_info "Cloning GitHub repository: $repo_url"
    
    if [ -d "$repo_path" ]; then
        log_warning "Directory $repo_path already exists"
        read -p "Do you want to remove it and clone fresh? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            rm -rf "$repo_path"
        else
            log_info "Opening existing project..."
            cd "$repo_path" && nvim .
            return 0
        fi
    fi
    
    cd "$PROJECT_DIR"
    if git clone "$repo_url"; then
        log_success "Repository cloned successfully"
        cd "$repo_name"
        log_info "Opening project in Neovim..."
        nvim .
    else
        log_error "Failed to clone repository"
        return 1
    fi
}

# Clone repository from GitLab
clone_gitlab_repo() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    local repo_path="$PROJECT_DIR/$repo_name"
    
    log_info "Cloning GitLab repository: $repo_url"
    
    if [ -d "$repo_path" ]; then
        log_warning "Directory $repo_path already exists"
        read -p "Do you want to remove it and clone fresh? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            rm -rf "$repo_path"
        else
            log_info "Opening existing project..."
            cd "$repo_path" && nvim .
            return 0
        fi
    fi
    
    cd "$PROJECT_DIR"
    if git clone "$repo_url"; then
        log_success "Repository cloned successfully"
        cd "$repo_name"
        log_info "Opening project in Neovim..."
        nvim .
    else
        log_error "Failed to clone repository"
        return 1
    fi
}

# Search and select GitHub repository
search_github_repo() {
    log_info "Searching GitHub repositories..."
    echo ""
    
    # Get user input for search
    read -p "Enter repository name or search term: " search_term
    
    if [ -z "$search_term" ]; then
        log_error "Search term cannot be empty"
        return 1
    fi
    
    # Search repositories
    local repos
    if repos=$(gh repo list --limit 20 --json nameWithOwner,description,url --jq '.[] | "\(.nameWithOwner) - \(.description // "No description")"'); then
        if [ -z "$repos" ]; then
            log_warning "No repositories found"
            return 1
        fi
        
        echo ""
        log_info "Found repositories:"
        echo "$repos" | nl -w2 -s'. '
        echo ""
        
        read -p "Select repository number (or 'q' to quit): " selection
        
        if [ "$selection" = "q" ]; then
            return 0
        fi
        
        # Get selected repository URL
        local repo_url
        repo_url=$(echo "$repos" | sed -n "${selection}p" | cut -d' ' -f1)
        
        if [ -n "$repo_url" ]; then
            clone_github_repo "https://github.com/$repo_url.git"
        else
            log_error "Invalid selection"
            return 1
        fi
    else
        log_error "Failed to search GitHub repositories"
        return 1
    fi
}

# Search and select GitLab repository
search_gitlab_repo() {
    log_info "Searching GitLab repositories..."
    echo ""
    
    # Get user input for search
    read -p "Enter repository name or search term: " search_term
    
    if [ -z "$search_term" ]; then
        log_error "Search term cannot be empty"
        return 1
    fi
    
    # Search repositories
    local repos
    if repos=$(glab repo list --limit 20 --json name,description,webUrl --jq '.[] | "\(.name) - \(.description // "No description")"'); then
        if [ -z "$repos" ]; then
            log_warning "No repositories found"
            return 1
        fi
        
        echo ""
        log_info "Found repositories:"
        echo "$repos" | nl -w2 -s'. '
        echo ""
        
        read -p "Select repository number (or 'q' to quit): " selection
        
        if [ "$selection" = "q" ]; then
            return 0
        fi
        
        # Get selected repository URL
        local repo_url
        repo_url=$(echo "$repos" | sed -n "${selection}p" | cut -d' ' -f1)
        
        if [ -n "$repo_url" ]; then
            clone_gitlab_repo "$repo_url"
        else
            log_error "Invalid selection"
            return 1
        fi
    else
        log_error "Failed to search GitLab repositories"
        return 1
    fi
}

# Create new GitHub repository
create_github_repo() {
    log_info "Creating new GitHub repository..."
    echo ""
    
    read -p "Repository name: " repo_name
    read -p "Description (optional): " repo_description
    read -p "Make it private? (y/N): " is_private
    
    local private_flag=""
    if [[ $is_private =~ ^[Yy]$ ]]; then
        private_flag="--private"
    else
        private_flag="--public"
    fi
    
    # Create repository on GitHub
    if gh repo create "$repo_name" --description "$repo_description" $private_flag; then
        log_success "Repository created on GitHub"
        
        # Clone the repository
        local repo_path="$PROJECT_DIR/$repo_name"
        cd "$PROJECT_DIR"
        
        if git clone "https://github.com/$(gh api user --jq .login)/$repo_name.git"; then
            log_success "Repository cloned locally"
            cd "$repo_name"
            
            # Initialize with basic files
            echo "# $repo_name" > README.md
            echo "$repo_description" >> README.md
            echo "" >> README.md
            echo "## Getting Started" >> README.md
            echo "" >> README.md
            echo "This project was created using the Universal Development Environment." >> README.md
            
            git add README.md
            git commit -m "Initial commit"
            git push -u origin main
            
            log_info "Opening project in Neovim..."
            nvim .
        else
            log_error "Failed to clone repository"
            return 1
        fi
    else
        log_error "Failed to create repository on GitHub"
        return 1
    fi
}

# Create new GitLab repository
create_gitlab_repo() {
    log_info "Creating new GitLab repository..."
    echo ""
    
    read -p "Repository name: " repo_name
    read -p "Description (optional): " repo_description
    read -p "Make it private? (y/N): " is_private
    
    local visibility="public"
    if [[ $is_private =~ ^[Yy]$ ]]; then
        visibility="private"
    fi
    
    # Create repository on GitLab
    if glab repo create "$repo_name" --description "$repo_description" --visibility "$visibility"; then
        log_success "Repository created on GitLab"
        
        # Clone the repository
        local repo_path="$PROJECT_DIR/$repo_name"
        cd "$PROJECT_DIR"
        
        if git clone "$(glab repo view --web)"; then
            log_success "Repository cloned locally"
            cd "$repo_name"
            
            # Initialize with basic files
            echo "# $repo_name" > README.md
            echo "$repo_description" >> README.md
            echo "" >> README.md
            echo "## Getting Started" >> README.md
            echo "" >> README.md
            echo "This project was created using the Universal Development Environment." >> README.md
            
            git add README.md
            git commit -m "Initial commit"
            git push -u origin main
            
            log_info "Opening project in Neovim..."
            nvim .
        else
            log_error "Failed to clone repository"
            return 1
        fi
    else
        log_error "Failed to create repository on GitLab"
        return 1
    fi
}

# Main dashboard menu
show_dashboard() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    🚀 PROJECT MANAGEMENT DASHBOARD 🚀                        ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  📁 Project Directory: $PROJECT_DIR${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  🔍 OPEN REPOSITORY:                                                         ║${NC}"
    echo -e "${CYAN}║    1. Open GitHub Repository    - Search and clone from GitHub              ║${NC}"
    echo -e "${CYAN}║    2. Open GitLab Repository    - Search and clone from GitLab              ║${NC}"
    echo -e "${CYAN}║    3. Open Local Repository     - Browse and open existing projects         ║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  🆕 CREATE NEW PROJECT:                                                      ║${NC}"
    echo -e "${CYAN}║    4. Create GitHub Project     - Create repo on GitHub and clone locally  ║${NC}"
    echo -e "${CYAN}║    5. Create GitLab Project     - Create repo on GitLab and clone locally  ║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  🛠️  UTILITIES:                                                              ║${NC}"
    echo -e "${CYAN}║    6. Check CLI Tools          - Verify GitHub/GitLab CLI installation     ║${NC}"
    echo -e "${CYAN}║    7. Set Project Directory     - Change default project directory          ║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║    0. Exit                                                                   ║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Browse local repositories
browse_local_repos() {
    log_info "Browsing local repositories in $PROJECT_DIR"
    echo ""
    
    if [ ! -d "$PROJECT_DIR" ]; then
        log_warning "Project directory does not exist: $PROJECT_DIR"
        read -p "Create it? (y/N): " create_dir
        if [[ $create_dir =~ ^[Yy]$ ]]; then
            mkdir -p "$PROJECT_DIR"
            log_success "Created project directory"
        else
            return 1
        fi
    fi
    
    # Find all git repositories
    local repos
    repos=$(find "$PROJECT_DIR" -maxdepth 2 -name ".git" -type d | sed 's|/.git||' | sed "s|$PROJECT_DIR/||" | sort)
    
    if [ -z "$repos" ]; then
        log_warning "No local repositories found"
        return 1
    fi
    
    echo "Local repositories:"
    echo "$repos" | nl -w2 -s'. '
    echo ""
    
    read -p "Select repository number (or 'q' to quit): " selection
    
    if [ "$selection" = "q" ]; then
        return 0
    fi
    
    local selected_repo
    selected_repo=$(echo "$repos" | sed -n "${selection}p")
    
    if [ -n "$selected_repo" ]; then
        local repo_path="$PROJECT_DIR/$selected_repo"
        log_info "Opening project: $selected_repo"
        cd "$repo_path" && nvim .
    else
        log_error "Invalid selection"
        return 1
    fi
}

# Set project directory
set_project_directory() {
    echo ""
    log_info "Current project directory: $PROJECT_DIR"
    echo ""
    read -p "Enter new project directory path: " new_dir
    
    if [ -n "$new_dir" ]; then
        PROJECT_DIR="$new_dir"
        log_success "Project directory set to: $PROJECT_DIR"
    else
        log_warning "No directory specified"
    fi
}

# Main menu loop
main_menu() {
    while true; do
        show_dashboard
        read -p "Select an option: " choice
        
        case $choice in
            1)
                search_github_repo
                ;;
            2)
                search_gitlab_repo
                ;;
            3)
                browse_local_repos
                ;;
            4)
                create_github_repo
                ;;
            5)
                create_gitlab_repo
                ;;
            6)
                check_cli_tools
                echo ""
                read -p "Press Enter to continue..."
                ;;
            7)
                set_project_directory
                echo ""
                read -p "Press Enter to continue..."
                ;;
            0)
                log_info "Goodbye! 👋"
                exit 0
                ;;
            *)
                log_error "Invalid option. Please try again."
                sleep 2
                ;;
        esac
    done
}

# Main execution
main() {
    log_info "Starting Project Management Dashboard..."
    echo ""
    
    # Check if CLI tools are available
    if ! check_cli_tools; then
        log_warning "Some CLI tools are missing, but you can still use local repository browsing"
        echo ""
        read -p "Continue anyway? (y/N): " continue_anyway
        if [[ ! $continue_anyway =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Start main menu
    main_menu
}

# Run main function
main "$@"
