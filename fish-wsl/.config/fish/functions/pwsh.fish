# Launch PowerShell
function pwsh
    tmux rename-window pwsh
    powershell.exe $argv
end
