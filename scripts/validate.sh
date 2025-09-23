#!/bin/bash

# Validation Script
# Validates the development environment setup

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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate core tools
validate_core_tools() {
    log_info "Validating core tools..."
    
    local tools=("git" "nvim" "node" "npm" "lazygit" "fzf" "ripgrep" "bat" "exa")
    local missing=()
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool is installed"
        else
            log_error "$tool is missing"
            missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing tools: ${missing[*]}"
        return 1
    fi
    
    return 0
}

# Validate Neovim configuration
validate_neovim() {
    log_info "Validating Neovim configuration..."
    
    if [ ! -f ~/.config/nvim/init.lua ]; then
        log_error "Neovim configuration not found"
        return 1
    fi
    
    # Test Neovim
    if nvim --version >/dev/null 2>&1; then
        log_success "Neovim is working"
    else
        log_error "Neovim test failed"
        return 1
    fi
    
    return 0
}

# Validate shell configuration
validate_shell() {
    log_info "Validating shell configuration..."
    
    if [ ! -f ~/.zshrc ]; then
        log_error "Shell configuration not found"
        return 1
    fi
    
    # Test shell
    if zsh -c "echo 'Shell test'" >/dev/null 2>&1; then
        log_success "Shell is working"
    else
        log_error "Shell test failed"
        return 1
    fi
    
    return 0
}

# Validate Git configuration
validate_git() {
    log_info "Validating Git configuration..."
    
    if [ -z "$(git config --global user.name)" ]; then
        log_error "Git user.name not set"
        return 1
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        log_error "Git user.email not set"
        return 1
    fi
    
    log_success "Git configuration is valid"
    return 0
}

# Validate scripts
validate_scripts() {
    log_info "Validating scripts..."
    
    local scripts=("daily.sh" "mobile.sh" "sync.sh" "validate.sh")
    local missing=()
    
    for script in "${scripts[@]}"; do
        if [ -f "scripts/$script" ]; then
            if [ -x "scripts/$script" ]; then
                log_success "$script is executable"
            else
                log_error "$script is not executable"
                missing+=("$script")
            fi
        else
            log_error "$script not found"
            missing+=("$script")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing or non-executable scripts: ${missing[*]}"
        return 1
    fi
    
    return 0
}

# Validate mobile setup
validate_mobile() {
    log_info "Validating mobile setup..."
    
    if [[ "$OSTYPE" == "android"* ]] || [[ -f /data/data/com.termux/files/usr/bin/termux-info ]]; then
        log_info "Android/Termux detected"
        
        if command_exists pkg; then
            log_success "Termux package manager available"
        else
            log_error "Termux package manager not available"
            return 1
        fi
    elif [[ -f /etc/alpine-release ]]; then
        log_info "iOS/iSH detected"
        
        if command_exists apk; then
            log_success "Alpine package manager available"
        else
            log_error "Alpine package manager not available"
            return 1
        fi
    else
        log_info "Desktop environment detected"
    fi
    
    return 0
}

# Validate sync setup
validate_sync() {
    log_info "Validating sync setup..."
    
    if [ ! -d ~/dev-sync ]; then
        log_warning "Sync directory not found"
        return 1
    fi
    
    if [ ! -d ~/dev-sync/.git ]; then
        log_warning "Sync git repository not initialized"
        return 1
    fi
    
    log_success "Sync setup is valid"
    return 0
}

# Main validation function
main() {
    log_info "Starting environment validation..."
    
    local errors=0
    
    # Run validations
    validate_core_tools || ((errors++))
    validate_neovim || ((errors++))
    validate_shell || ((errors++))
    validate_git || ((errors++))
    validate_scripts || ((errors++))
    validate_mobile || ((errors++))
    validate_sync || ((errors++))
    
    if [ $errors -eq 0 ]; then
        log_success "All validations passed!"
        exit 0
    else
        log_error "Validation failed with $errors errors"
        exit 1
    fi
}

# Run main function
main "$@"

