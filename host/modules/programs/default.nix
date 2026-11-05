{ pkgs, ... }: {
  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
    sway.enable = true;
    chromium.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
    ];
  };
}
