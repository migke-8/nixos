{pkgs}: let
in
  with pkgs; [
    mako
    waybar
    wofi
    grim
    foot
    dunst
    rofi
    ringboard
    libnotify
    wl-clipboard
    swaylock
    sway-contrib.grimshot
    swaybg
    swayidle
  ]
