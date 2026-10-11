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
export VISUAL='nvim'

# -------------------------
# Local binaries
# -------------------------
export PATH="$HOME/.local/bin:$PATH"

# -------------------------
# Terminal title
# -------------------------
# Reset the title at every prompt so WezTerm stops treating this pane as
# Neovim (which titles itself "nvim ...") once Neovim exits.
autoload -Uz add-zsh-hook
_set_title() { print -Pn "\e]2;%~\a" }
add-zsh-hook precmd _set_title

# -------------------------
# Starship prompt
# -------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
