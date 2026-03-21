{
  config,
  pkgs,
  ...
}: {
  home.file.".config/rofi/config.rasi" = {
    source = ./config.rasi;
    force = true;
  };
  programs.rofi = {
    enable = true;
  };
}
