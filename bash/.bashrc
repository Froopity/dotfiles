[[ $- != *i* ]] && return

# Shell behavior
shopt -s checkwinsize
shopt -s globstar
shopt -s cdspell
shopt -s no_empty_cmd_completion

# History
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
export HISTTIMEFORMAT='%F %T  '
shopt -s histappend

# Tab completion for git, systemctl, etc.
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

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

# Color everywhere else that supports it
export LESS='-R -F -X'
command -v dircolors >/dev/null 2>&1 && eval "$(dircolors -b)"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Prompt: full path with early segments shortened to the current one, git
# branch if inside a repo, input line on its own row.
__prompt_pwd() {
  local dir=${PWD/#$HOME/\~}
  local prefix=
  if [[ $dir == /* ]]; then
    prefix=/
    dir=${dir#/}
  fi

  local IFS=/
  local -a parts=($dir)
  local last=$(( ${#parts[@]} - 1 ))
  local out= seg i

  for i in "${!parts[@]}"; do
    seg=${parts[$i]}
    if [[ $i -eq $last ]]; then
      out+="$seg"
    elif [[ $seg == .* ]]; then
      out+="${seg:0:2}/"
    else
      out+="${seg:0:1}/"
    fi
  done

  printf '%s%s' "$prefix" "$out"
}

__prompt_git() {
  local branch
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || branch=$(git rev-parse --short HEAD 2>/dev/null) || return
  printf ' (%s)' "$branch"
}

PS1='\[\e[1;34m\]$(__prompt_pwd)\[\e[0m\]\[\e[90m\]$(__prompt_git)\[\e[0m\]\n\$ '

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

# Readline / key bindings
bind '"\e[3;5~": kill-word'              # Ctrl-Delete
bind '"\C-h": backward-kill-word'        # Ctrl-Backspace (plain Backspace usually sends \x7f, not \C-h)
bind '"\e[A": history-search-backward'   # Up: filter history by what's typed so far
bind '"\e[B": history-search-forward'    # Down: same, forward
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
