{ config, pkgs, ... }: 
{
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "unstable";
  imports = [
    # ./home/ringboard.nix
    ./home/foot.nix
    ./home/git.nix
    ./home/tmux.nix
    ./home/vim.nix
    ./home/kitty.nix
    ./home/zsh.nix
    ./home/nvim.nix
    ./home/rofi.nix
  ];
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "chromium.desktop" ];
    };
  };

  home.packages = [ pkgs.chromium pkgs.ringboard-wayland ];
}
