if status is-interactive

    if not command -q bat; and command -q batcat
        alias bat=batcat
    end

    set -x MANROFFOPT -c
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

    fish_add_path ~/.local/bin

    # franciscolourenco/done notification settings
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low

    export EDITOR="nvim"
    alias editor="$EDITOR"
    alias edit="editor"
    alias vi="editor"
    alias nconfig="cd ~/.config/nvim && $EDITOR ."

    export PROFILE="~/.config/fish"
    alias profile="editor $PROFILE"
    alias config="editor $PROFILE"
    alias reload="exec fish"

end
