#!/bin/bash

# Fix zsh compinit insecure files issue
echo "=== FIXING ZSH COMPINIT ISSUE ==="
echo ""

# Fix completion file permissions
echo "🔧 Fixing completion file permissions..."
chmod -R 755 ~/.zcompdump* 2>/dev/null || true
chmod -R 755 ~/.zsh* 2>/dev/null || true
chmod -R 755 ~/.oh-my-zsh 2>/dev/null || true

# Remove problematic completion files
echo "📋 Cleaning up problematic completion files..."
rm -f ~/.zcompdump* 2>/dev/null || true

# Set proper environment variables
echo "🔧 Setting environment variables..."
export ZSH_DISABLE_COMPFIX=true
export ZSH_COMPDUMP="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/zcompdump"

# Create cache directory if it doesn't exist
mkdir -p ~/.cache/zsh

# Update .zshrc with proper compinit configuration
echo "📋 Updating .zshrc configuration..."
cat >> ~/.zshrc << 'EOF'

# Fix compinit insecure files issue
ZSH_DISABLE_COMPFIX=true
autoload -U compinit
compinit -u

# Alternative: Force compinit to ignore insecure files
# compinit -u -d ~/.cache/zsh/zcompdump
EOF

echo "✅ ZSH compinit issue fixed!"
echo "📋 Restart your terminal to apply changes"
echo "🚀 No more 'insecure files' prompts!"
