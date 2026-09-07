# A simple tool for calling tmux scripts
# Place scripts into TMUX_SCRIPT_DIR.
# Call scripts with `t <script>`
# Scripts can be grouped by simply placing them in directories and calling that e.g. `t git/status_dash`
# The .sh extension is optional

set TMUX_SCRIPT_DIR /home/will/tmux/scripts

function t \
    --argument-names script_name

    if test -z "$script_name"
        # Fuzzy search script dir if no arg provided
        set script_file (fzf --no-multi --walker-root=$TMUX_SCRIPT_DIR)
        if test $status -gt 0
            return $status
        end
    else
        # Add .sh to script name if not present
        if not string match -q --regex '\.sh$' $script_name
            set script_name (string join '' $script_name '.sh')
        end

        set script_file (string join '/' $TMUX_SCRIPT_DIR $script_name)
    end

    if not test -e $script_file
        # In theory fzf shouldn't hit this but still useful in exceptional cases
        echo "Script with name '$script_file' not found"
        return 1
    end

    command $script_file
end
