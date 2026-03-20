{
  config,
  pkgs,
  ...
}: {
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  imports = [
    ./home/waybar.nix
    ./home/sway.nix
    ./home/foot.nix
    ./home/git.nix
    ./home/zsh.nix
    ./home/nvim.nix
    ./home/rofi.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["chromium.desktop"];
    };
  };
}
