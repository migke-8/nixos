{ config, pkgs, ... }: 
{
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        font = "MononokiNerdFontMono:size=15";
        "box-drawings-uses-font-glyphs" = "yes";
        "selection-target" = "both";
      };
      cursor = {
        style = "underline";
        "unfocused-style" = "none";
        "underline-thickness" = "2px";
        blink = true;
      };
      colors = {
        background="272822";
        foreground="fdfff1";
        regular0="6e7066";
        regular1="f92672";
        regular2="a6e12e";
        regular3="e2db74";
        regular4="fb9027";
        regular5="ae81ff";
        regular6="66d9ef";
        regular7="fdfff1";
        bright0="86887b";
        bright1="FF6188";
        bright2="A9DC76";
        bright3="FFD866";
        bright4="FC9867";
        bright5="AB9DF2";
        bright6="78DCE8";
        bright7="FFFFFF";
        alpha = 0.9;
      };
    };
  };
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "cache --timeout=21600";
      init.defaultBranch = "main";
      safe.directory = [
        "/etc/nixos"
      ];
      user = {
        name = "migke-8";
        email = "miguelportelabispo@gmail.com";
      };
    };
  };
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set -g mouse on
      setw -g mode-keys vi

      # Use Vim keybindings in copy-mode
      bind -Tcopy-mode-vi 'v' send -X begin-selection
      bind -Tcopy-mode-vi 'y' send -X copy-selection-and-cancel
      bind -Tcopy-mode-vi 'V' send -X select-line

      # Pane switching with vim keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes with vim keys + prefix
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Split panes Vim-style
      bind | split-window -h
      bind - split-window -v

      # Reload configuration
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux reloaded!"

      # Better status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-interval 5

      # Use 256 colors
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
