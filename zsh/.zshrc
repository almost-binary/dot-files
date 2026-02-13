setopt autocd
setopt hist_ignore_all_dups
setopt share_history

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit

for file in aliases.zsh functions.zsh plugins.zsh; do
  [[ -f "$ZDOTDIR/$file" ]] && source "$ZDOTDIR/$file"
done
