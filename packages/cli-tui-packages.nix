{pkgs}: let
in
  with pkgs; [
    claude-code
    gemini-cli
    watchexec
    gzip
    smartmontools
    jq
    htop
    wget
    curl
    zip
    unzip
    clamav
  ]
