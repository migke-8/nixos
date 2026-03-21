{pkgs}: let
in
  with pkgs; [
    mako
    grim
    dunst
    libnotify
    wl-clipboard
    swaylock
    sway-contrib.grimshot
    swaybg
    swayidle
    nnn
    cava
  ]
