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
