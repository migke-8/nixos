# dev enviroment
autoload -U add-zsh-hook
STATE_FILE="$HOME/.zsh_dev_state"

if [[ -f "$STATE_FILE" ]]; then
    export default_cd=$(sed -n "1p" "$STATE_FILE")
else
    export default_cd="$HOME"
fi

# Create a helper function to update it across sessions
set_state() {
    echo "$1\n$2" > "$STATE_FILE"
    export default_cd="$1"
    export NIX_SHELL="$2"
}
export default_cd="${default_cd:-$HOME}"
handle_nix_enviroment() {
  if [[ -f flake.nix ]] ; then
    if [[ -z $NIX_SHELL ]] ; then
      while [[ true ]]; do
        echo "flake.nix found, do you wish to enter development enviroment?(y/n)"
        read ENTER_ENV
        if [[ $ENTER_ENV == "n" || $ENTER_ENV == "N" ]] ; then
          return
        elif [[ $ENTER_ENV == "y" || $ENTER_ENV == "Y" ]] ; then
          break 
        fi
      done
      echo "flake.nix found. Entering nix develop environment..."
      echo "updating default cd enviroment..."
      set_state "$(pwd)" "in"
      exec nix develop -c "zsh" || echo "Failed to enter nix develop. Returning to previous shell."
    fi
  fi
}
on_exit() {
  rm $STATE_FILE
}
add-zsh-hook chpwd handle_nix_enviroment
add-zsh-hook zshexit on_exit
handle_nix_enviroment
cd $default_cd
