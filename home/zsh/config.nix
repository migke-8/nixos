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
      NNN_TRASH = 1;
      NIXOS_HOME = "$HOME/nixos";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initContent = builtins.readFile ./init.sh;
    shellAliases = {
      ll = "ls -l";
      ls = "ls --color";
      update = "sudo nixos-rebuild switch --flake $NIXOS_HOME#nixos";
      upgrade = "sudo nixos-rebuild switch --upgrade --flake $NIXOS_HOME#nixos";
    };
  };
}
