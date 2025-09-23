#!/bin/bash

# Manual plugin update script
echo "=== MANUAL PLUGIN UPDATE ==="
echo ""
echo "🔧 To update plugins manually:"
echo ""
echo "1. Open Neovim: nvim"
echo "2. Run these commands:"
echo "   :Lazy sync"
echo "   :Lazy update" 
echo "   :TSUpdate"
echo ""
echo "📋 Or run this one-liner:"
echo "nvim -c 'Lazy sync' -c 'Lazy update' -c 'TSUpdate' -c 'quit'"
echo ""
echo "✅ This will update all LazyVim plugins including nvim-treesitter"
