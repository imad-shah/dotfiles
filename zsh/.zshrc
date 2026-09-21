# -------------------------
# Zsh autosuggestions
# -------------------------
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Accept autosuggestion with Ctrl+F
bindkey '^f' autosuggest-accept

# -------------------------
# Zsh syntax highlighting
# -------------------------
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------------------------
# Aliases
# -------------------------
alias ..='cd ..'
alias cc='claude --dangerously-skip-permissions'
alias co='codex -- --full-auto'
alias quota='quota-axi --tui'
alias szsh='source ~/.zshrc'

# -------------------------
# Editor
# -------------------------
export EDITOR='nvim'

# -------------------------
# Starship prompt
# -------------------------
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
