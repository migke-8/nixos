{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    keyMode = "vi";
    
    # Additional Vim-style keybindings for pane navigation and selection
    extraConfig = ''
      # Vim-style pane selection / movement
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim-style pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Vim-style copy mode selection and copying
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
    '';
  };
}
