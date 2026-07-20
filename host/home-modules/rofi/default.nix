{
  config,
  pkgs,
  home,
  ...
}: {
  programs.rofi = {
    enable = true;
    theme = ./.config/config.rasi;
  };
}
