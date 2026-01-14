{ pkgs, ... }:
with pkgs; [
  pcsx2
  retroarch
  libretro.swanstation
  gtk3
  glib
  gsettings-desktop-schemas
]
