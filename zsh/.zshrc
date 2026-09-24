# -------------------------
# Platform-specific setup
# -------------------------
case "$(uname -s)" in
    Darwin)
        source "$HOME/dotfiles/zsh/platform/macos.zsh"
        ;;
    Linux)
        source "$HOME/dotfiles/zsh/platform/linux.zsh"
        ;;
esac

# -------------------------
# Aliases
# -------------------------
alias ..='cd ..'
alias cc='claude --dangerously-skip-permissions'
alias co='codex --yolo'
alias quota='quota-axi --tui'
alias szsh='source ~/.zshrc'
alias zshrc='nvim ~/dotfiles/zsh/.zshrc'

# -------------------------
# Editor
# -------------------------
export EDITOR='nvim'

# -------------------------
# Local binaries
# -------------------------
export PATH="$HOME/.local/bin:$PATH"

# -------------------------
# Starship prompt
# -------------------------
eval "$(starship init zsh)"
