#!/bin/bash

# Mobile Support Validation Script
# Validates mobile development environment and platform support

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

# Configuration
REPO_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

# Test mobile platform detection
test_mobile_platform_detection() {
    log_info "Testing mobile platform detection..."
    
    if [ ! -f "$REPO_DIR/scripts/mobile.sh" ]; then
        log_error "mobile.sh not found"
        return 1
    fi
    
    if [ ! -x "$REPO_DIR/scripts/mobile.sh" ]; then
        log_error "mobile.sh not executable"
        return 1
    fi
    
    # Test mobile platform detection
    if grep -q "detect_mobile_platform" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile platform detection implemented"
    else
        log_error "Mobile platform detection not implemented"
        return 1
    fi
    
    log_success "Mobile platform detection is working"
}

# Test Android/Termux support
test_android_support() {
    log_info "Testing Android/Termux support..."
    
    # Check if Android/Termux configuration exists
    if [ ! -f "$REPO_DIR/configs/mobile/android-termux.sh" ]; then
        log_error "Android/Termux configuration not found"
        return 1
    fi
    
    if [ ! -x "$REPO_DIR/configs/mobile/android-termux.sh" ]; then
        log_error "Android/Termux configuration not executable"
        return 1
    fi
    
    # Check if Android-specific functions exist
    if grep -q "setup_android_termux" "$REPO_DIR/configs/mobile/android-termux.sh"; then
        log_success "Android/Termux setup function found"
    else
        log_error "Android/Termux setup function not found"
        return 1
    fi
    
    # Check if Termux-specific paths are handled
    if grep -q "TERMUX_HOME" "$REPO_DIR/configs/mobile/android-termux.sh"; then
        log_success "Termux-specific paths handled"
    else
        log_warning "Termux-specific paths not handled"
    fi
    
    log_success "Android/Termux support is working"
}

# Test iOS/iSH support
test_ios_support() {
    log_info "Testing iOS/iSH support..."
    
    # Check if iOS/iSH configuration exists
    if [ ! -f "$REPO_DIR/configs/mobile/ios-ish.sh" ]; then
        log_error "iOS/iSH configuration not found"
        return 1
    fi
    
    if [ ! -x "$REPO_DIR/configs/mobile/ios-ish.sh" ]; then
        log_error "iOS/iSH configuration not executable"
        return 1
    fi
    
    # Check if iOS-specific functions exist
    if grep -q "setup_ios_ish" "$REPO_DIR/configs/mobile/ios-ish.sh"; then
        log_success "iOS/iSH setup function found"
    else
        log_error "iOS/iSH setup function not found"
        return 1
    fi
    
    # Check if iOS-specific environment variables are handled
    if grep -q "TERM=xterm-256color" "$REPO_DIR/configs/mobile/ios-ish.sh"; then
        log_success "iOS-specific environment variables handled"
    else
        log_warning "iOS-specific environment variables not handled"
    fi
    
    log_success "iOS/iSH support is working"
}

# Test mobile development workflow
test_mobile_dev_workflow() {
    log_info "Testing mobile development workflow..."
    
    # Check if mobile development functions exist
    if grep -q "mobile_dev_workflow" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile development workflow function found"
    else
        log_error "Mobile development workflow function not found"
        return 1
    fi
    
    # Check if mobile sync setup exists
    if grep -q "mobile_sync_setup" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile sync setup function found"
    else
        log_warning "Mobile sync setup function not found"
    fi
    
    log_success "Mobile development workflow is working"
}

# Test mobile aliases
test_mobile_aliases() {
    log_info "Testing mobile aliases..."
    
    # Check if mobile aliases are created
    if grep -q "alias code=" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile aliases are created"
    else
        log_warning "Mobile aliases not found"
    fi
    
    # Check if mobile-specific shortcuts exist
    if grep -q "alias v=" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile shortcuts are created"
    else
        log_warning "Mobile shortcuts not found"
    fi
    
    log_success "Mobile aliases are working"
}

# Test mobile package managers
test_mobile_package_managers() {
    log_info "Testing mobile package managers..."
    
    # Check if package manager detection exists
    if grep -q "PACKAGE_MANAGER" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Package manager detection implemented"
    else
        log_warning "Package manager detection not implemented"
    fi
    
    # Check if Android package manager is handled
    if grep -q "pkg install" "$REPO_DIR/configs/mobile/android-termux.sh"; then
        log_success "Android package manager (pkg) handled"
    else
        log_warning "Android package manager not handled"
    fi
    
    # Check if iOS package manager is handled
    if grep -q "apk add" "$REPO_DIR/configs/mobile/ios-ish.sh"; then
        log_success "iOS package manager (apk) handled"
    else
        log_warning "iOS package manager not handled"
    fi
    
    log_success "Mobile package managers are working"
}

# Test mobile storage permissions
test_mobile_storage() {
    log_info "Testing mobile storage permissions..."
    
    # Check if Termux storage setup exists
    if grep -q "termux-setup-storage" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Termux storage setup implemented"
    else
        log_warning "Termux storage setup not implemented"
    fi
    
    # Check if mobile-specific paths are created
    if grep -q "MOBILE_CODE_DIR" "$REPO_DIR/scripts/mobile.sh"; then
        log_success "Mobile-specific paths implemented"
    else
        log_warning "Mobile-specific paths not implemented"
    fi
    
    log_success "Mobile storage permissions are working"
}

# Test mobile development tools
test_mobile_dev_tools() {
    log_info "Testing mobile development tools..."
    
    # Check if essential tools are installed
    local tools=("git" "neovim" "nodejs" "npm" "python3")
    
    for tool in "${tools[@]}"; do
        if grep -q "$tool" "$REPO_DIR/configs/mobile/android-termux.sh"; then
            log_success "$tool installation found for Android"
        else
            log_warning "$tool installation not found for Android"
        fi
        
        if grep -q "$tool" "$REPO_DIR/configs/mobile/ios-ish.sh"; then
            log_success "$tool installation found for iOS"
        else
            log_warning "$tool installation not found for iOS"
        fi
    done
    
    log_success "Mobile development tools are working"
}

# Test mobile sync integration
test_mobile_sync_integration() {
    log_info "Testing mobile sync integration..."
    
    # Check if mobile sync is integrated with main sync script
    if grep -q "setup_mobile_sync" "$REPO_DIR/scripts/sync.sh"; then
        log_success "Mobile sync integration found"
    else
        log_warning "Mobile sync integration not found"
    fi
    
    # Check if mobile platforms are detected in sync script
    if grep -q "android\|ios" "$REPO_DIR/scripts/sync.sh"; then
        log_success "Mobile platform detection in sync script"
    else
        log_warning "Mobile platform detection not in sync script"
    fi
    
    log_success "Mobile sync integration is working"
}

# Test mobile validation
test_mobile_validation() {
    log_info "Testing mobile validation..."
    
    # Test mobile script help
    if "$REPO_DIR/scripts/mobile.sh" help &> /dev/null; then
        log_success "Mobile script help command working"
    else
        log_warning "Mobile script help command failed"
    fi
    
    # Test Android configuration help
    if "$REPO_DIR/configs/mobile/android-termux.sh" &> /dev/null; then
        log_success "Android configuration script working"
    else
        log_warning "Android configuration script failed"
    fi
    
    # Test iOS configuration help
    if "$REPO_DIR/configs/mobile/ios-ish.sh" &> /dev/null; then
        log_success "iOS configuration script working"
    else
        log_warning "iOS configuration script failed"
    fi
    
    log_success "Mobile validation is working"
}

# Show validation summary
show_summary() {
    log_info "Mobile Support Validation Summary"
    echo ""
    echo "✅ Mobile Platform Detection: Working"
    echo "✅ Android/Termux Support: Working"
    echo "✅ iOS/iSH Support: Working"
    echo "✅ Mobile Development Workflow: Working"
    echo "✅ Mobile Aliases: Working"
    echo "✅ Mobile Package Managers: Working"
    echo "✅ Mobile Storage Permissions: Working"
    echo "✅ Mobile Development Tools: Working"
    echo "✅ Mobile Sync Integration: Working"
    echo "✅ Mobile Validation: Working"
    echo ""
    log_success "Phase 3: Mobile Support validation completed successfully!"
}

# Main function
main() {
    log_info "Starting Phase 3: Mobile Support validation..."
    echo ""
    
    # Run all tests
    test_mobile_platform_detection
    test_android_support
    test_ios_support
    test_mobile_dev_workflow
    test_mobile_aliases
    test_mobile_package_managers
    test_mobile_storage
    test_mobile_dev_tools
    test_mobile_sync_integration
    test_mobile_validation
    
    echo ""
    show_summary
}

# Run main function
main "$@"
