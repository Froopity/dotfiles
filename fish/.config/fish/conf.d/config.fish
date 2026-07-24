if status is-interactive

    set -l bat_cmd bat
    if not command -q bat; and command -q batcat
        alias bat=batcat
        set bat_cmd batcat
    end

    set -x MANROFFOPT -c
    set -x MANPAGER "sh -c 'col -bx | $bat_cmd -l man -p'"

    fish_add_path ~/.local/bin

    # franciscolourenco/done notification settings
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low

    export EDITOR="nvim"
    alias editor="$EDITOR"
    alias edit="editor"
    alias vi="editor"
    alias nconfig="cd ~/.config/nvim && $EDITOR ."

    alias profile="config"
    alias reload="exec fish"

    # Typo correction
    alias exiot="exit"
    alias exot="exit"

    function mkcd
        mkdir -p $argv
        cd $argv
    end

    function lt
        if string match -qr '^-?[0-9]+(\.?[0-9]*)?$' -- "$argv[1]"
            ls --tree --level $argv
        else
            ls --tree --level 2 $argv
        end
    end

    function history
        builtin history --show-time='%F %T ' $argv
    end

    function uv-help
        echo '# /// script'
        echo '# dependencies = ['
        echo '#   "rich",'
        echo '# ]'
        echo '# ///'
    end

    function fish_rm_path --argument path
        set path (path resolve $path)
        set path_index (contains -i $path $fish_user_paths)

        if test $status -ne 0
            echo $path not in fish_user_paths
            return 1
        end

        echo Removing $path at index $path_index from fish_user_paths

        set -e fish_user_paths[$path_index]
    end

    function config --description 'Fuzzy-open a file in the dotfiles repo, or a path if given'
        set -l dotfiles ~/dotfiles

        if test (count $argv) -gt 0
            editor $dotfiles/$argv
            return
        end

        set -l previewer cat
        if command -q bat
            set previewer bat --color=always
        else if command -q batcat
            set previewer batcat --color=always
        end

        set -l finder find $dotfiles -type f -not -path '*/.git/*'
        if command -q fd
            set finder fd --type f --hidden --exclude .git . $dotfiles
        end

        set -l file ($finder | fzf --preview "$previewer {}")
        test -n "$file"; and editor $file
    end

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

    # Auto-picks git.exe under Windows-mounted paths (/mnt/*), otherwise native git
    function g
        if string match -q '/mnt/*' -- $PWD
            git.exe $argv
        else
            /usr/bin/git $argv
        end
    end

    alias gs="g status"
    alias gl="g log"
    alias ga="g add"
    alias gc="g commit"
    alias gb="g branch"
    alias gp="g push"
    alias gpl="g pull"

    abbr --add greptail "stdbuf -o0 grep"

    # Directories to always skip in Ctrl-T/Alt-C search (matched by name, not full path).
    set -gx FZF_DEFAULT_OPTS "--walker-skip=.git,node_modules,.venv,venv,__pycache__,dist,build,target,.cache"
    set -gx FZF_CTRL_T_OPTS "--walker=file,dir,hidden"
    set -gx FZF_ALT_C_OPTS "--walker=dir,hidden"

    fzf --fish | source

    if test -f ~/.config/fish/fzf-git.sh/fzf-git.fish
        source ~/.config/fish/fzf-git.sh/fzf-git.fish
    end

    bind ctrl-delete kill-word
    bind ctrl-backspace backward-kill-word

    zoxide init fish | source

    function __ssh_agent_is_started -d "check if ssh agent is already started"
        if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
            source $SSH_ENV > /dev/null
        end

        if test -z "$SSH_AGENT_PID"
            return 1
        end

        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
        return $status
    end

    function __ssh_agent_start -d "start a new ssh agent"
        ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
        chmod 600 $SSH_ENV
        source $SSH_ENV > /dev/null
        true
    end

    function fish_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
        if test -z "$SSH_ENV"
            set -xg SSH_ENV $HOME/.ssh/environment
        end

        if not __ssh_agent_is_started
            __ssh_agent_start
        end
    end

    fish_ssh_agent

end
