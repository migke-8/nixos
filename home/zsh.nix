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
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
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
      update = "sudo nixos-rebuild switch";
      upgrade = "sudo nixos-rebuild switch";
    };
  };
}
