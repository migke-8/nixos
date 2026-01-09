{ config, pkgs, ... }: 
{
  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  imports = [
    ./home/foot.nix
    ./home/git.nix
    ./home/tmux.nix
    ./home/vim.nix
  ];
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "chromium.desktop" ];
    };
  };

  home.packages = [ pkgs.chromium ];
}
