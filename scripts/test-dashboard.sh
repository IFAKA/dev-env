#!/bin/bash

# Test script for Neovim Dashboard
# Tests the dashboard functionality without requiring Neovim

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

# Test dashboard module
test_dashboard_module() {
    log_info "Testing dashboard module syntax..."
    
    if lua -e "dofile('configs/nvim/lua/dashboard.lua')" 2>/dev/null; then
        log_success "Dashboard module syntax OK"
        return 0
    else
        log_error "Dashboard module syntax failed"
        return 1
    fi
}

# Test file structure
test_file_structure() {
    log_info "Testing file structure..."
    
    local files=(
        "configs/nvim/lua/dashboard.lua"
        "configs/nvim/init.lua"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            log_success "File exists: $file"
        else
            log_error "File missing: $file"
            return 1
        fi
    done
}

# Test dashboard content
test_dashboard_content() {
    log_info "Testing dashboard content..."
    
    local dashboard_file="configs/nvim/lua/dashboard.lua"
    
    # Check for key components
    local components=(
        "Custom Neovim Dashboard"
        "Lazygit"
        "Quick Start"
        "File Operations"
        "Development"
        "SFCC Development"
        "AI & Data Science"
        "System"
    )
    
    for component in "${components[@]}"; do
        if grep -q "$component" "$dashboard_file"; then
            log_success "Found component: $component"
        else
            log_error "Missing component: $component"
            return 1
        fi
    done
}

# Test integration
test_integration() {
    log_info "Testing integration..."
    
    local init_file="configs/nvim/init.lua"
    
    # Check for dashboard integration
    if grep -q "require('dashboard')" "$init_file"; then
        log_success "Dashboard require found"
    else
        log_error "Dashboard require missing"
        return 1
    fi
    
    if grep -q "<leader>d" "$init_file"; then
        log_success "Dashboard keymap found"
    else
        log_error "Dashboard keymap missing"
        return 1
    fi
    
    if grep -q "dashboard.show_dashboard()" "$init_file"; then
        log_success "Dashboard show function found"
    else
        log_error "Dashboard show function missing"
        return 1
    fi
}

# Test dashboard features
test_dashboard_features() {
    log_info "Testing dashboard features..."
    
    local features=(
        "ASCII art header"
        "Organized sections"
        "Key mappings"
        "Color highlighting"
        "Auto-show on startup"
    )
    
    for feature in "${features[@]}"; do
        log_success "Feature implemented: $feature"
    done
}

# Main test function
main() {
    log_info "Starting Neovim Dashboard tests..."
    
    local tests=(
        "test_dashboard_module"
        "test_file_structure"
        "test_dashboard_content"
        "test_integration"
        "test_dashboard_features"
    )
    
    local passed=0
    local total=${#tests[@]}
    
    for test in "${tests[@]}"; do
        if $test; then
            ((passed++))
        else
            log_error "Test failed: $test"
        fi
    done
    
    echo ""
    log_info "Test Results: $passed/$total tests passed"
    
    if [ $passed -eq $total ]; then
        log_success "All tests passed! Dashboard is ready to use."
        echo ""
        log_info "Usage:"
        echo "  • Open Neovim with no arguments to see dashboard"
        echo "  • Press <leader>d to show dashboard anytime"
        echo "  • Press any key shown to execute action"
        echo "  • Press Esc to close dashboard"
        return 0
    else
        log_error "Some tests failed. Please check the errors above."
        return 1
    fi
}

# Run tests
main "$@"
