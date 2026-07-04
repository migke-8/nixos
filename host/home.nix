{lib, pkgs, ...}: {
  imports = builtins.filter
    (path: lib.hasSuffix ".nix" (builtins.toString path))
    (lib.fileset.toList ./home-modules);
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "26.11";
  home.packages = with pkgs; [
    # apps
    rofi
    # cli
    ripgrep
    # fonts
    nerd-fonts.arimo
    nerd-fonts.mononoki
  ];


}
