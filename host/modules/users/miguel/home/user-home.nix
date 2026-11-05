{ lib, pkgs, ... }: {
  imports = builtins.filter
    (path: lib.hasSuffix ".nix" (builtins.toString path))
    (lib.fileset.toList ./modules);
  home = {
    username = "miguel";
    homeDirectory = "/home/miguel";
    stateVersion = "26.11";
    packages = with pkgs; [
      # Applications
      rofi
      # CLI
      ripgrep
      # Fonts
      nerd-fonts.arimo
      nerd-fonts.mononoki
    ];
  };
}
