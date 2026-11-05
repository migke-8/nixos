{ config
, pkgs
, home
, ...
}: {
  home.packages = with pkgs; [
    rofi
  ];
  xdg.configFile."rofi/config.rasi".source = ./.config/config.rasi;
}
