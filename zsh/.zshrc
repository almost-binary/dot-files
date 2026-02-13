setopt autocd
setopt hist_ignore_all_dups
setopt share_history

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit

setopt prompt_subst
autoload -Uz add-zsh-hook

for file in aliases.zsh functions.zsh plugins.zsh; do
  [[ -f "$ZDOTDIR/$file" ]] && source "$ZDOTDIR/$file"
done

typeset -gi PROMPT_LAST_STATUS=0

_update_prompt() {
  local git_seg status_seg

  git_seg=$(git_prompt_segment)
  if (( PROMPT_LAST_STATUS == 0 )); then
    status_seg='%F{green}✓%f'
  else
    status_seg='%F{red}x%f'
  fi

  PROMPT="${status_seg} %F{246}%n@%m%f:%F{244}%~%f"
  [[ -n "$git_seg" ]] && PROMPT+=" %F{242}${git_seg}%f"
  PROMPT+=" %# "
}

_prompt_precmd() {
  PROMPT_LAST_STATUS=$?
  _update_prompt
}

add-zsh-hook precmd _prompt_precmd
_prompt_precmd
