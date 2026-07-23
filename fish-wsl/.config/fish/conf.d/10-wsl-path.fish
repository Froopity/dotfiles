if status is-interactive

    # Remove Windows NVM from PATH (if present)
    set -gx PATH (string match -v "/mnt/c/ProgramData/nvm" $PATH)
    set -gx PATH (string match -v "/mnt/c/Program Files/nodejs/" $PATH)
    set -gx PATH (string match -v "/mnt/c/nvm4w/nodejs" $PATH)

    # Ensure WSL NVM paths are at the start of PATH
    set -gx PATH $HOME/.nvm/versions/node/(nvm current)/bin $PATH

end
