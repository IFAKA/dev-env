#!/bin/bash

# Update LazyVim plugins
echo "=== UPDATING LAZYVIM PLUGINS ==="
echo ""

echo "🔧 Updating nvim-treesitter and all plugins..."
echo "📋 Running LazyVim plugin updates..."

# Open Neovim and run LazyVim commands
nvim --headless -c "Lazy sync" -c "Lazy update" -c "TSUpdate" -c "quit" 2>&1

echo ""
echo "✅ Plugin updates completed!"
echo "📋 All plugins should now be up to date"
echo "🚀 LazyVim is ready to use!"
