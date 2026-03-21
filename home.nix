{
  config,
  pkgs,
  ...
}: {
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  imports = [
    ./home/sway/config.nix
    ./home/waybar.nix
    ./home/foot.nix
    ./home/git.nix
    ./home/zsh.nix
    ./home/nvim.nix
    ./home/rofi/config.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["chromium.desktop"];
    };
  };
  home.packages = [
    pkgs.nerd-fonts.arimo
    pkgs.nerd-fonts.mononoki
  ];
}
