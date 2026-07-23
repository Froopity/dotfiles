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

end
