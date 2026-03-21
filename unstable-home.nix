{pkgs, ...}: {

  home.username = "miguel";
  home.homeDirectory = "/home/miguel";
  home.stateVersion = "25.11";
  imports = [
    ./home/git.nix
    ./home/neovim/config.nix
    ./home/zsh/config.nix
  ];
}
