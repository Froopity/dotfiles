# Launch Command Prompt
function cmd
    tmux rename-window cmd
    cmd.exe $argv
end
