if status is-interactive

    # Replace ls with eza
    alias ls='eza -al --color=always --group-directories-first --icons=always'
    alias la='eza -a --color=always --group-directories-first --icons=always'
    alias ll='eza -l --color=always --group-directories-first --icons=always'
    alias l.="eza -a | grep -e '^\.'"

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

    alias gs="g status"
    alias gl="g log"
    alias ga="g add"
    alias gc="g commit"
    alias gb="g branch"
    alias gp="g push"
    alias gpl="g pull"

    abbr --add greptail "stdbuf -o0 grep"

end
