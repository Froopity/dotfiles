if status is-interactive

    set -gx JIRA_TUI_ENV_FILE ~/.config/jiratui/.env.jiratui

    alias kill_node="taskkill.exe /f /im node.exe"
    alias tasklist="tasklist.exe"
    alias op="op.exe"
    alias subl="subl.exe"
    alias jira="jiratui.exe"
    alias lg="lazygit.exe"
    alias hc="uv.exe tool run hc"

    alias update_aws="cp /mnt/c/Users/Will/.aws/config ~/.aws/config"

    # Don't follow symlinks in Ctrl-T/Alt-C: Windows compat junctions under /mnt/c
    # (e.g. "Documents and Settings") loop back into the home tree otherwise.
    # OneDrive dirs are also excluded here since they're slow to walk and irrelevant.
    # Appends to core's FZF_DEFAULT_OPTS - relies on work-config.fish loading after
    # config.fish (conf.d sources alphabetically, "c" < "w").
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS,OneDrive,'OneDrive - Onyx','OneDrive - Onyx Tech Pty Ltd',Onyx"

    function cdw
        if test (count $argv) -lt 1
            cd /mnt/c/work
        else
            cd /mnt/c/work/$argv
        end
    end

    function pf --no-scope-shadowing
        set -l second_arg
        if test (count $argv) -lt 2
            set second_arg (test "$argv[1]" = "sandbox" && echo "admin" || echo "support")
        else
            set second_arg (test "$argv[2]" = "infra" && echo "infrastructure-manager" || echo $argv[2])
        end
        echo onyxtech.$argv[1].$second_arg
    end

    function pfp
        set profile (pf $argv)
        echo --profile $profile
    end

    function login
        set cmd1 "aws sso login --profile onyxtech.horus.support"
        set cmd2 aws.exe sso login --profile onyxtech.horus.support

        set file_path /var/tmp/script/login-time

        if test -e $file_path
            set file_mod_time (stat -c %Y $file_path)
            set current_time (date +%s)
            set time_diff (math $current_time - $file_mod_time)

            if test $time_diff -lt 30 # 43200 = 12 hours
                fish -c $cmd1 >/dev/null & $cmd2 >/dev/null

                mkdir -p (dirname $file_path)
                touch $file_path
                return
            end
        end

        eval $cmd1 >/dev/null
        eval $cmd2 >/dev/null

        mkdir -p (dirname $file_path)
        touch $file_path
    end

    function update-hc
        uv.exe tool install --upgrade git+https://bitbucket.org/onyxtech-au/horus-aws-toolkit.git
    end

    function hcl
        fish -c "cd /mnt/c/work/source/horus-aws-toolkit;
      uv.exe run --frozen toolkit/hc.py $argv"
    end

    function lm
        fish -c "cd /mnt/c/work/source/lazymanager;
      uv run --frozen lazymanager/lazymanager.py $argv"
    end

end

function fish_greeting
    set -q TMUX
    and return

    set -l art_lines '🌊🌊⛵🌊🌊🌊🌊🌊' '    ｜ 🐠•°°~' ' 🦀 ⚓        🐟'
    set -l art_widths 16 13 15
    set -l gap_to 18

    set -l sessions (tmux list-sessions -f '#{==:#{session_attached},0}' \
        -F '#{session_activity}|#{session_name} (#{session_windows}w)' 2>/dev/null \
        | sort -t'|' -k1,1nr | cut -d'|' -f2)
    set -l sessions $sessions[1..3]

    for i in (seq 3)
        set -l gap (string repeat -n (math $gap_to - $art_widths[$i]) ' ')
        set -l right ''
        if set -q sessions[$i]
            set right (set_color yellow)"• "(set_color normal)$sessions[$i]
        end
        echo "$art_lines[$i]$gap$right"
    end
end
