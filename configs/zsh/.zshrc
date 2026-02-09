# Fix zsh compinit insecure directories warning
ZSH_DISABLE_COMPFIX=true

# Zsh Autosuggestions - ghost text that predicts what you'll type
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add the custom alias
alias gpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias lastmodified="git show --name-only --pretty=format:'' HEAD"
alias gpm="git pull origin master"

export TERM=xterm-256color
export COLORTERM=truecolor
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Ollama CORS - allow Chrome extension access
export OLLAMA_ORIGINS="*"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# VimZap aliases
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
# VimZap aliases end
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt
eval "$(starship init zsh)"
