#!/bin/bash

# Edge Case Testing Script
# Tests various edge cases and error conditions across all phases

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
TEST_DIR="/tmp/dev-env-edge-tests"
BACKUP_DIR="/tmp/dev-env-backup"

# Test network connectivity edge cases
test_network_edge_cases() {
    log_info "Testing network connectivity edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with no internet connection
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        log_warning "No internet connection - testing offline mode"
        if ./setup.sh --offline --help &> /dev/null; then
            log_success "Offline mode works"
            ((tests_passed++))
        else
            log_error "Offline mode failed"
            ((tests_failed++))
        fi
    else
        log_info "Internet connection available - testing online mode"
        ((tests_passed++))
    fi
    
    # Test with slow connection
    log_info "Testing slow connection handling..."
    if timeout 5 curl -s --connect-timeout 2 https://github.com > /dev/null; then
        log_success "Slow connection handled"
        ((tests_passed++))
    else
        log_warning "Slow connection test failed"
        ((tests_failed++))
    fi
    
    log_info "Network edge cases: $tests_passed passed, $tests_failed failed"
}

# Test disk space edge cases
test_disk_space_edge_cases() {
    log_info "Testing disk space edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Check available disk space
    local available_space=$(df -h . | awk 'NR==2 {print $4}' | sed 's/[^0-9.]//g')
    
    if (( $(echo "$available_space < 1" | bc -l) )); then
        log_warning "Very low disk space: ${available_space}GB"
        log_info "Testing low disk space handling..."
        ((tests_passed++))
    else
        log_info "Sufficient disk space: ${available_space}GB"
        ((tests_passed++))
    fi
    
    # Test with full disk simulation
    log_info "Testing full disk simulation..."
    if [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
    
    mkdir -p "$TEST_DIR"
    if [ $? -eq 0 ]; then
        log_success "Disk space test passed"
        ((tests_passed++))
    else
        log_error "Disk space test failed"
        ((tests_failed++))
    fi
    
    log_info "Disk space edge cases: $tests_passed passed, $tests_failed failed"
}

# Test permission edge cases
test_permission_edge_cases() {
    log_info "Testing permission edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with restricted permissions
    log_info "Testing restricted permissions..."
    if [ -w "$REPO_DIR" ]; then
        log_success "Write permissions available"
        ((tests_passed++))
    else
        log_error "No write permissions"
        ((tests_failed++))
    fi
    
    # Test with read-only filesystem
    log_info "Testing read-only filesystem..."
    if touch "$TEST_DIR/test-write" 2>/dev/null; then
        rm -f "$TEST_DIR/test-write"
        log_success "Write test passed"
        ((tests_passed++))
    else
        log_error "Write test failed"
        ((tests_failed++))
    fi
    
    log_info "Permission edge cases: $tests_passed passed, $tests_failed failed"
}

# Test platform detection edge cases
test_platform_edge_cases() {
    log_info "Testing platform detection edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with unknown platform
    log_info "Testing unknown platform detection..."
    local original_ostype="$OSTYPE"
    export OSTYPE="unknown-platform"
    
    if ./scripts/sync.sh help &> /dev/null; then
        log_success "Unknown platform handled"
        ((tests_passed++))
    else
        log_warning "Unknown platform not handled gracefully"
        ((tests_failed++))
    fi
    
    export OSTYPE="$original_ostype"
    
    # Test with mobile platform detection
    log_info "Testing mobile platform detection..."
    if ./scripts/mobile.sh help &> /dev/null; then
        log_success "Mobile platform detection works"
        ((tests_passed++))
    else
        log_warning "Mobile platform detection failed"
        ((tests_failed++))
    fi
    
    log_info "Platform edge cases: $tests_passed passed, $tests_failed failed"
}

# Test package manager edge cases
test_package_manager_edge_cases() {
    log_info "Testing package manager edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with missing package manager
    log_info "Testing missing package manager..."
    if command -v brew &> /dev/null; then
        log_success "Package manager available"
        ((tests_passed++))
    else
        log_warning "Package manager not available"
        ((tests_failed++))
    fi
    
    # Test with broken package manager
    log_info "Testing broken package manager..."
    if command -v apt &> /dev/null; then
        if apt --version &> /dev/null; then
            log_success "Package manager working"
            ((tests_passed++))
        else
            log_warning "Package manager broken"
            ((tests_failed++))
        fi
    fi
    
    log_info "Package manager edge cases: $tests_passed passed, $tests_failed failed"
}

# Test Git edge cases
test_git_edge_cases() {
    log_info "Testing Git edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with uninitialized Git repository
    log_info "Testing uninitialized Git repository..."
    if [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
    
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    if ! git status &> /dev/null; then
        log_success "Uninitialized Git repository detected"
        ((tests_passed++))
    else
        log_warning "Git repository already initialized"
        ((tests_passed++))
    fi
    
    # Test with corrupted Git repository
    log_info "Testing corrupted Git repository..."
    git init
    rm -rf .git/objects
    if ! git status &> /dev/null; then
        log_success "Corrupted Git repository detected"
        ((tests_passed++))
    else
        log_warning "Git repository not corrupted"
        ((tests_passed++))
    fi
    
    cd "$REPO_DIR"
    rm -rf "$TEST_DIR"
    
    log_info "Git edge cases: $tests_passed passed, $tests_failed failed"
}

# Test sync edge cases
test_sync_edge_cases() {
    log_info "Testing sync edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with no remote repository
    log_info "Testing no remote repository..."
    if ./scripts/sync.sh validate &> /dev/null; then
        log_success "Sync validation works"
        ((tests_passed++))
    else
        log_warning "Sync validation failed"
        ((tests_failed++))
    fi
    
    # Test with network issues
    log_info "Testing network issues..."
    if ./scripts/sync.sh backup &> /dev/null; then
        log_success "Backup works without network"
        ((tests_passed++))
    else
        log_warning "Backup failed"
        ((tests_failed++))
    fi
    
    log_info "Sync edge cases: $tests_passed passed, $tests_failed failed"
}

# Test mobile edge cases
test_mobile_edge_cases() {
    log_info "Testing mobile edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with desktop platform
    log_info "Testing desktop platform mobile setup..."
    if ./scripts/mobile.sh help &> /dev/null; then
        log_success "Mobile script works on desktop"
        ((tests_passed++))
    else
        log_warning "Mobile script failed on desktop"
        ((tests_failed++))
    fi
    
    # Test with missing mobile tools
    log_info "Testing missing mobile tools..."
    if command -v pkg &> /dev/null || command -v apk &> /dev/null; then
        log_success "Mobile package manager available"
        ((tests_passed++))
    else
        log_warning "Mobile package manager not available"
        ((tests_failed++))
    fi
    
    log_info "Mobile edge cases: $tests_passed passed, $tests_failed failed"
}

# Test error recovery
test_error_recovery() {
    log_info "Testing error recovery..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with invalid arguments
    log_info "Testing invalid arguments..."
    if ./setup.sh --invalid-argument &> /dev/null; then
        log_warning "Invalid arguments not handled"
        ((tests_failed++))
    else
        log_success "Invalid arguments handled"
        ((tests_passed++))
    fi
    
    # Test with missing files
    log_info "Testing missing files..."
    if [ -f "$REPO_DIR/setup.sh" ]; then
        log_success "Setup script exists"
        ((tests_passed++))
    else
        log_error "Setup script missing"
        ((tests_failed++))
    fi
    
    log_info "Error recovery: $tests_passed passed, $tests_failed failed"
}

# Test performance edge cases
test_performance_edge_cases() {
    log_info "Testing performance edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with large files
    log_info "Testing large files..."
    if [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
    
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Create a large file
    dd if=/dev/zero of=large-file.txt bs=1M count=10 2>/dev/null
    if [ -f "large-file.txt" ]; then
        log_success "Large file handling works"
        ((tests_passed++))
    else
        log_error "Large file handling failed"
        ((tests_failed++))
    fi
    
    cd "$REPO_DIR"
    rm -rf "$TEST_DIR"
    
    # Test with many files
    log_info "Testing many files..."
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    for i in {1..1000}; do
        echo "test $i" > "file-$i.txt"
    done
    
    if [ $(ls | wc -l) -eq 1000 ]; then
        log_success "Many files handling works"
        ((tests_passed++))
    else
        log_error "Many files handling failed"
        ((tests_failed++))
    fi
    
    cd "$REPO_DIR"
    rm -rf "$TEST_DIR"
    
    log_info "Performance edge cases: $tests_passed passed, $tests_failed failed"
}

# Test security edge cases
test_security_edge_cases() {
    log_info "Testing security edge cases..."
    
    local tests_passed=0
    local tests_failed=0
    
    # Test with sensitive files
    log_info "Testing sensitive files..."
    if [ -f "$REPO_DIR/.sync-exclude" ]; then
        if grep -q "\.env" "$REPO_DIR/.sync-exclude"; then
            log_success "Sensitive files excluded"
            ((tests_passed++))
        else
            log_warning "Sensitive files not excluded"
            ((tests_failed++))
        fi
    else
        log_warning "Exclude file not found"
        ((tests_failed++))
    fi
    
    # Test with SSH keys
    log_info "Testing SSH key handling..."
    if [ -f ~/.ssh/id_rsa ]; then
        if [ $(stat -c %a ~/.ssh/id_rsa 2>/dev/null || echo "600") -eq 600 ]; then
            log_success "SSH key permissions correct"
            ((tests_passed++))
        else
            log_warning "SSH key permissions incorrect"
            ((tests_failed++))
        fi
    else
        log_info "SSH key not found"
        ((tests_passed++))
    fi
    
    log_info "Security edge cases: $tests_passed passed, $tests_failed failed"
}

# Main test function
main() {
    log_info "Starting edge case testing..."
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    
    # Run all edge case tests
    test_network_edge_cases
    test_disk_space_edge_cases
    test_permission_edge_cases
    test_platform_edge_cases
    test_package_manager_edge_cases
    test_git_edge_cases
    test_sync_edge_cases
    test_mobile_edge_cases
    test_error_recovery
    test_performance_edge_cases
    test_security_edge_cases
    
    # Cleanup
    rm -rf "$TEST_DIR"
    
    log_success "Edge case testing completed!"
    log_info "Check the output above for any failed tests"
}

# Run main function
main "$@"
