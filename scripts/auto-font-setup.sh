#!/bin/bash

# Automatic Font Setup for Universal Development Environment
# Works with Ghostty, Terminal, and other terminals

echo "=== AUTOMATIC FONT SETUP ==="
echo ""

# Check if Ghostty is available
if command -v ghostty &> /dev/null; then
    echo "🎯 Ghostty detected - configuring automatically..."
    
    # Create Ghostty config directory
    mkdir -p ~/.config/ghostty
    
    # Create Ghostty config with Nerd Font
    cat > ~/.config/ghostty/config << 'EOF'
# Ghostty Configuration for Universal Dev Environment
font-family = "JetBrainsMono Nerd Font"
font-size = 12

# Colors
background = "#1e1e2e"
foreground = "#cdd6f4"

# Cursor
cursor-style = "block"
cursor-color = "#f5e0dc"
EOF
    
    echo "✅ Ghostty configured with Nerd Font"
    echo "📋 Ghostty config created at ~/.config/ghostty/config"
    
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    echo "🎯 Apple Terminal detected - creating font profile..."
    
    # Create a script to set Terminal font
    cat > ~/set-terminal-font.sh << 'EOF'
#!/bin/bash
# Script to set Terminal font to Nerd Font
osascript << 'APPLESCRIPT'
tell application "Terminal"
    set default settings to settings set "Pro"
    set font name of default settings to "JetBrainsMono Nerd Font"
    set font size of default settings to 12
end tell
APPLESCRIPT
EOF
    
    chmod +x ~/set-terminal-font.sh
    ~/set-terminal-font.sh
    
    echo "✅ Terminal font set to Nerd Font"
    echo "📋 Run ~/set-terminal-font.sh if needed again"
    
else
    echo "🎯 Other terminal detected - manual setup required"
    echo "📋 Please set your terminal font to 'JetBrainsMono Nerd Font'"
fi

echo ""
echo "🚀 Font setup complete!"
echo "📋 Restart your terminal to see proper icons"
echo ""
echo "🔧 Available Nerd Fonts:"
ls ~/Library/Fonts/ | grep -i nerd | head -3
echo ""
echo "✅ Icons should now display properly instead of squares!"
