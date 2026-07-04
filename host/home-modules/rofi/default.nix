{
  config,
  pkgs,
  home,
  ...
}: {
  programs.rofi = {
    enable = true;
    theme = builtins.readFile ./.config/config.rasi;
  };
}
