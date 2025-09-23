# Universal Zsh Configuration
# Optimized for cross-device development

# Path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# Options
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Key bindings
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Aliases
source ~/.zsh_aliases

# Functions
# Quick directory navigation
d() {
  if [ -z "$1" ]; then
    dirs -v
  else
    cd "+$1"
  fi
}

# Quick file editing
e() {
  if [ -z "$1" ]; then
    nvim .
  else
    nvim "$1"
  fi
}

# Quick git operations
g() {
  case "$1" in
    "a") git add . ;;
    "c") git commit -m "$2" ;;
    "p") git push ;;
    "s") git status ;;
    "l") git log --oneline -10 ;;
    "d") git diff ;;
    "b") git branch ;;
    "co") git checkout "$2" ;;
    "lg") lazygit ;;
    *) git "$@" ;;
  esac
}

# Development shortcuts
dev() {
  case "$1" in
    "start") ~/dev-env/scripts/daily.sh ;;
    "mobile") ~/dev-env/scripts/mobile.sh ;;
    "sync") ~/dev-env/scripts/sync.sh ;;
    "sfcc") cd ~/code/sfcc-project ;;
    "next") cd ~/code/nextjs-app ;;
    "leetcode") leetcode-cli ;;
    "task") task ;;
    *) echo "Usage: dev [start|mobile|sync|sfcc|next|leetcode|task]" ;;
  esac
}

# Mobile optimizations
if [[ "$OSTYPE" == "android"* ]] || [[ -f /data/data/com.termux/files/usr/bin/termux-info ]]; then
  # Android/Termux specific
  export TERMUX_HOME="/data/data/com.termux/files/home"
  export PATH="$TERMUX_HOME/bin:$PATH"
  
  # Touch-friendly aliases
  alias ll='ls -la'
  alias la='ls -A'
  alias l='ls -CF'
  
  # Mobile-specific functions
  mobile_edit() {
    if [ -z "$1" ]; then
      nvim .
    else
      nvim "$1"
    fi
  }
  
  alias e=mobile_edit
fi

# iOS/iSH specific
if [[ -f /etc/alpine-release ]]; then
  # iSH specific configurations
  export PATH="/usr/local/bin:$PATH"
  
  # Touch-friendly aliases
  alias ll='ls -la'
  alias la='ls -A'
  alias l='ls -CF'
fi

# Auto-completion
if command -v brew &> /dev/null; then
  # macOS with Homebrew
  if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
  
  if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
elif command -v pkg &> /dev/null; then
  # Android/Termux
  if [ -f "$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
  
  if [ -f "$PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
fi

# FZF integration
if command -v fzf &> /dev/null; then
  if command -v brew &> /dev/null; then
    [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
    [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  elif [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
  fi
fi

# Node.js version management
if command -v nvm &> /dev/null; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Python virtual environment
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Development environment detection
if [ -f "$HOME/dev-env/scripts/daily.sh" ]; then
  export DEV_ENV_HOME="$HOME/dev-env"
  export PATH="$DEV_ENV_HOME/scripts:$PATH"
fi

# Prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # Simple prompt
  PROMPT='%F{blue}%n@%m%f %F{green}%~%f %# '
fi

# Welcome message
if [[ $- == *i* ]]; then
  echo "🚀 Universal Development Environment loaded"
  echo "Run 'dev start' to begin your workflow"
fi

