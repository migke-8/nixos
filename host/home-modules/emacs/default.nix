{ pkgs, ... }: {
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.magit
      epkgs.dracula-theme
    ];

    extraConfig = ''
      (setq standard-indent 2)
      (load-theme 'dracula t)
    '';
  };
}
