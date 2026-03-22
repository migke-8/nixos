{
  pkgs,
  ...
}: {
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  imports = [
    ./home/sway/config.nix
    ./home/waybar/config.nix
    ./home/foot.nix
    ./home/rofi/config.nix
    ./home/gammastep.nix
    ./home/git.nix
    ./home/neovim/config.nix
    ./home/zsh/config.nix
  ];

  home.packages = [
    pkgs.rofi
    pkgs.nerd-fonts.arimo
    pkgs.nerd-fonts.mononoki
  ];
}
