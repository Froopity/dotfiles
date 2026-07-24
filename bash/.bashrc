[[ $- != *i* ]] && return

# Colored man pages via bat, falls back to the default pager when unavailable
if command -v bat >/dev/null 2>&1; then
  bat_cmd=bat
elif command -v batcat >/dev/null 2>&1; then
  bat_cmd=batcat
  alias bat=batcat
fi

if [[ -n $bat_cmd ]]; then
  # -c makes groff emit backspace-overstrike formatting instead of SGR codes,
  # so `col -bx` can strip it cleanly before bat re-highlights the page.
  export MANROFFOPT=-c
  export MANPAGER="sh -c 'col -bx | $bat_cmd -l man -p'"
fi
unset bat_cmd

alias reload='exec bash'

# Typo correction
alias exiot='exit'
alias exot='exit'

mkcd() {
  mkdir -p "$@" && cd "$1" || return
}

if command -v eza >/dev/null 2>&1; then
  alias ls='eza -al --color=always --group-directories-first --icons=always'
  alias la='eza -a --color=always --group-directories-first --icons=always'
  alias ll='eza -l --color=always --group-directories-first --icons=always'
  alias l.="eza -a | grep -e '^\.'"

  lt() {
    if [[ $1 =~ ^-?[0-9]+(\.[0-9]*)?$ ]]; then
      eza -al --color=always --group-directories-first --icons=always --tree --level "$@"
    else
      eza -al --color=always --group-directories-first --icons=always --tree --level 2 "$@"
    fi
  }
fi

# Common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tb='nc termbin.com 9999'

# Auto-picks git.exe under Windows-mounted paths (/mnt/*), otherwise native git
g() {
  if [[ $PWD == /mnt/* ]]; then
    git.exe "$@"
  else
    /usr/bin/git "$@"
  fi
}

alias gs='g status'
alias gl='g log'
alias ga='g add'
alias gc='g commit'
alias gb='g branch'
alias gp='g push'
alias gpl='g pull'

export HISTTIMEFORMAT='%F %T  '

config() {
  local dotfiles=~/dotfiles/bash

  if [[ $# -gt 0 ]]; then
    "${EDITOR:-vi}" "$dotfiles/$*"
    return
  fi

  local previewer=cat
  if command -v bat >/dev/null 2>&1; then
    previewer='bat --color=always'
  elif command -v batcat >/dev/null 2>&1; then
    previewer='batcat --color=always'
  fi

  local file
  if command -v fd >/dev/null 2>&1; then
    file=$(fd --type f --hidden --exclude .git . "$dotfiles" | fzf --preview "$previewer {}")
  else
    file=$(find "$dotfiles" -type f -not -path '*/.git/*' | fzf --preview "$previewer {}")
  fi

  [[ -n $file ]] && "${EDITOR:-vi}" "$file"
}

alias profile=config

# Directories to always skip in Ctrl-T/Alt-C search (matched by name, not full path).
export FZF_DEFAULT_OPTS="--walker-skip=.git,node_modules,.venv,venv,__pycache__,dist,build,target,.cache"
export FZF_CTRL_T_OPTS="--walker=file,dir,hidden"
export FZF_ALT_C_OPTS="--walker=dir,hidden"

eval "$(fzf --bash)"

if [[ -f ~/.config/fzf-git.sh/fzf-git.sh ]]; then
  source ~/.config/fzf-git.sh/fzf-git.sh
fi

bind '"\e[3;5~": kill-word'         # Ctrl-Delete
bind '"\C-h": backward-kill-word'   # Ctrl-Backspace (plain Backspace usually sends \x7f, not \C-h)
