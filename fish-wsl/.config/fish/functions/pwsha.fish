# Launch Admin PowerShell
function pwsha
    tmux rename-window pwsh
    powershell.exe -Command "Start-Process powershell -Verb RunAs"
end
