{ pkgs, ... }: 
with pkgs; [
  # gaming
  pcsx2
  retroarch
  libretro.swanstation
  gtk3
  glib
  gsettings-desktop-schemas
  # UI setup
  mako
  waybar
  wofi
  grim
  foot
  # custom rice
  dunst
  rofi
  ringboard
  kitty
  libnotify
  wl-clipboard
  swaylock
  sway-contrib.grimshot
  swaybg
  swayidle
  emacs
  # coding
  musl
  jetbrains.idea-community
  cmake
  vscode
  claude-code
  gnumake
  chromium
  # CLIs and TUIs
  watchexec
  smartmontools
  jq
  htop
  wget
  curl
  zip
  unzip
  clamav

  # just use in a flake:
  # LSPs
  # lemminx
  # luajitPackages.lua-lsp
  # bash-language-server
  # nodePackages.vscode-langservers-extracted
  # typescript-language-server
  # vscode-css-languageserver
  # jdt-language-server
  # clang-tools
  # svelte-language-server
  # browsers
]
