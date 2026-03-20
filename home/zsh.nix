{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "nvim";
      VISUAL = "nvim";
      HISTSIZE = 1000000000;
      SAVEHIST = 1000000000;
      ZSH_THEME_NAME = "theme";
      PATH =
        "$PATH:$JAVA_HOME/bin"
        + "$PATH:$HOME/.local/bin"
        + "HOME/bin:$HOME/bin/custom-scripts:$PATH";
      NNN_TRASH = 1;
      NIXOS_HOME = "$HOME/nixos";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initContent = ''
      # important !!!!!!!!!
      echo "before coding:"
      echo "- create timers"
      echo "- make a checklist"
      echo "- when learning: focus on only one thing"

      # dev enviroment
      # autoload -U add-zsh-hook
      # STATE_FILE="$HOME/.zsh_dev_state"
      #
      # if [[ -f "$STATE_FILE" ]]; then
      #     export default_cd=$(sed -n "1p" "$STATE_FILE")
      # else
      #     export default_cd="$HOME"
      # fi
      #
      # 3. Create a helper function to update it across sessions
      # set_state() {
      #     echo "$1\n$2" > "$STATE_FILE"
      #     export default_cd="$1"
      #     export IN_NIX_SHELL="$2"
      # }
      # export default_cd="''${default_cd:-$HOME}"
      # handle_nix_enviroment() {
      #   if [[ -f flake.nix ]] ; then
      #     if [[ -z $IN_NIX_SHELL ]] ; then
      #       echo "flake.nix found. Entering nix develop environment..."
      #       echo "updating default cd enviroment..."
      #       exec nix develop -c "zsh" || echo "Failed to enter nix develop. Returning to previous shell."
      #       set_default_cd "$(pwd)"
      #       export IN_NIX_SHELL="in"
      #     fi
      #   else
      #     if [[ -n "$IN_NIX_SHELL" ]]; then
      #       set_state
      #     fi
      #   fi
      # }
      # on_exit() {
      #   rm $STATE_FILE
      # }
      # add-zsh-hook chpwd handle_nix_enviroment
      # add-zsh-hook zshexit on_exit
      # handle_nix_enviroment
      # cd $default_cd

      # theme
      setopt PROMPT_SUBST
      local THEME_FILE="/etc/nixos/config/zsh/theme.zsh"
      [ -f "$THEME_FILE" ] && source $THEME_FILE || echo "theme with name \"$ZSH_THEME_NAME\" was not found\n"

      # auto completion
      autoload -U compinit; compinit
      _comp_options+=(globdots)
      zstyle ':completion:*' menu select
      zstyle ':completion:*' file-sort modification

      # history
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      # Use [[ -n ]] to check if terminfo caps exist before binding
      [[ -n "''${terminfo[kcuu1]}" ]] && bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
      [[ -n "''${terminfo[kcud1]}" ]] && bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
    '';
    shellAliases = {
      ll = "ls -l";
      ls = "ls --color";
      update = "sudo nixos-rebuild switch --flake $NIXOS_HOME#nixos";
      upgrade = "sudo nixos-rebuild switch --upgrade --flake $NIXOS_HOME#nixos";
    };
  };
}
