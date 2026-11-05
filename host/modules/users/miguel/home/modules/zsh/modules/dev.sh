# dev enviroment
autoload -U add-zsh-hook

get_current_workspace_number() {
  swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name'
}

STATE_FILE="$HOME/.zsh_dev_state_ws-$(get_current_workspace_number)"

# Create a helper function to update it across sessions
set_state() {
    printf "%s\n%s\n%s" "$1" "$2" "$3" > "$STATE_FILE"
    export default_cd="$1"
    export NIX_SHELL="$2"
}
get_saved_workspace_number() {
  sed -n "3p" "$STATE_FILE"
}

enter() {
  echo "Entering nix develop environment..."
  echo "updating default cd enviroment..."
  set_state "$(pwd)" "in" "$(get_current_workspace_number)"
  exec nix develop -c "zsh" || echo "Failed to enter nix develop. Returning to previous shell."
}

if [[ -f "$STATE_FILE"  ]] && [[ $(get_saved_workspace_number) -eq $(get_current_workspace_number) ]]; then
    export default_cd
    default_cd="$(sed -n "1p" "$STATE_FILE")"
else
    export default_cd="$HOME"
fi

export default_cd="${default_cd:-$HOME}"

handle_nix_enviroment() {
  if [[ -f flake.nix ]] ; then
    if [[ ! -f $STATE_FILE ]]; then
      while true; do
        echo "flake.nix found, do you wish to enter development enviroment?(y/n)"
        read -r ENTER_ENV
        if [[ $ENTER_ENV == "n" || $ENTER_ENV == "N" ]] ; then
          return
        elif [[ $ENTER_ENV == "y" || $ENTER_ENV == "Y" ]] ; then
          break 
        fi
      done
      # saving state and exec env
      enter
    fi
    if [[ -f $STATE_FILE ]] && [[ $(get_saved_workspace_number) -eq $(get_current_workspace_number) ]] && [[ -z $NIX_SHELL ]] ; then
      # saving state and exec env without asking permission (because it is already set for this workspace)
      enter
    fi
  else 
    [[ ! -f "$default_cd/flake.nix" ]] && [[ -f $STATE_FILE ]] && rm "$STATE_FILE"
  fi
}
handle_exit() {
  # Give a small delay to ensure the current process is fully exiting
  sleep 1

  # Count other zsh processes with an associated TTY (pseudo-terminal) for the current user
  local zsh_count
  zsh_count=$(pgrep -u "$USER" -x zsh | wc -l)
  # parent process name
  local term_name
  term_name="$(ps -o comm= -p $PPID)"
  local term_count
  term_count=$(pgrep -u "$USER" -x "$term_name" | wc -l)
  # If you are the only zsh process left (zsh_count returns 0 after this one exits)
  # or if no other PTYs are open
  if [[ "$zsh_count" -le 1 ]] || [[ "$term_count" -le 1 ]]; then
    rm "$STATE_FILE"
  fi
}
on_exit() {
  handle_exit &
}
add-zsh-hook chpwd handle_nix_enviroment
add-zsh-hook zshexit on_exit
handle_nix_enviroment
cd "$default_cd" || exit
