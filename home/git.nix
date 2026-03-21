{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.unstable.git;
    settings = {
      credential.helper = "cache --timeout=21600";
      init.defaultBranch = "main";
      safe.directory = [
        "/etc/nixos"
      ];
      user = {
        name = "migke-8";
        email = "miguelportelabispo@gmail.com";
      };
    };
  };
}
