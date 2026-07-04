{
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
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initContent = ''
      source ${./modules/reminder.sh}
      source ${./modules/dev.sh}
      source ${./modules/completion.sh}
      source ${./modules/history.sh}
      # theme
      setopt PROMPT_SUBST
      local THEME_FILE="${./themes/theme-0.zsh}"
      [ -f "$THEME_FILE" ] && source $THEME_FILE || echo "theme with name \"$ZSH_THEME_NAME\" was not found\n"
'';
    shellAliases = {
      ll = "ls -l";
      ls = "ls --color";
      update = "sudo nixos-rebuild switch";
      upgrade = "sudo nixos-rebuild switch";
    };
  };
}
