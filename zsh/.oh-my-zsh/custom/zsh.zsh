# ZSH options
setopt nonomatch # I forgot what this does but I remember I'm used to it already, so keeping that (something about the wildcard glob)

# Aliases
alias z-config="vim ~/.zshrc"
alias z-history="vim ~/.zsh_history +:$"

# Load Pywal Theme
PYWAL_APPLY_COLORS_FILE=~/.cache/wal/sequences
([ -e $PYWAL_APPLY_COLORS_FILE ] && cat $PYWAL_APPLY_COLORS_FILE &)
