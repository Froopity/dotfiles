if status is-interactive

    # Remove Windows NVM from PATH (if present)
    set -gx PATH (string match -v "/mnt/c/ProgramData/nvm" $PATH)
    set -gx PATH (string match -v "/mnt/c/Program Files/nodejs/" $PATH)
    set -gx PATH (string match -v "/mnt/c/nvm4w/nodejs" $PATH)

    # Ensure WSL NVM paths are at the start of PATH
    set -gx PATH $HOME/.nvm/versions/node/(nvm current)/bin $PATH

    # Send cwd to Windows Terminal
    function storePathForWindowsTerminal --on-variable PWD
        if test -n "$WT_SESSION"
            printf "\e]9;9;%s\e\\" (wslpath -w "$PWD")
        end
    end

    # Launch PowerShell
    function pwsh
        tmux rename-window pwsh
        powershell.exe $argv
    end

    # Launch Command Prompt
    function cmd
        tmux rename-window cmd
        cmd.exe $argv
    end

    # Launch Admin PowerShell
    function pwsha
        tmux rename-window pwsh
        powershell.exe -Command "Start-Process powershell -Verb RunAs"
    end

    function notify-send
        wsl-notify-send.exe --category $WSL_DISTRO_NAME $argv
    end

end
