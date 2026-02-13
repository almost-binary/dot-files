mkcd() {
  mkdir -p "$1" && cd "$1"
}

git_prompt_segment() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch flags counts sync_flags dirty_flags
  local -i ahead=0
  local -i behind=0

  branch=$(
    command git symbolic-ref --quiet --short HEAD 2>/dev/null ||
      command git rev-parse --short HEAD 2>/dev/null
  ) || return

  dirty_flags=""

  if ! command git -c core.quotepath=false diff --no-ext-diff --quiet --exit-code 2>/dev/null; then
    dirty_flags+="!"
  fi

  if ! command git -c core.quotepath=false diff --no-ext-diff --cached --quiet --exit-code 2>/dev/null; then
    dirty_flags+="+"
  fi

  sync_flags=""
  if command git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1; then
    counts=$(command git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
    if [[ -n "$counts" ]]; then
      read -r behind ahead <<< "$counts"
    fi
    (( ahead > 0 )) && sync_flags+="↑${ahead} "
    (( behind > 0 )) && sync_flags+="↓${behind} "
  fi

  flags="${sync_flags}${dirty_flags}"
  flags="${flags% }"
  [[ -z "$flags" ]] && flags='='
  print -r -- "git:${branch}[${flags}]"
}
