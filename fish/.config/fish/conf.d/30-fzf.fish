if status is-interactive

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

end
