export TMUX_SCRIPT_DIR=/home/will/tmux/scripts

function t() {

  local script_name
  local script_file

  if [[ $# -eq 0 ]]; then
    # Fuzzy search script dir if no arg provided
    script_file=$(fzf --no-multi --walker-root="$TMUX_SCRIPT_DIR") || return
  else
    # Add .sh to script name if not present
    if ! [[ $script_name =~ \.sh$ ]]; then
      script_name="$1.sh"
    fi

    script_file="$TMUX_SCRIPT_DIR/$script_name"

  fi

  if ! [[ -e $script_file ]]; then
    echo "Script with name '$script_file' not found"
    return 1
  fi

  command $script_file
}

