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
    bat
    man-pages
    man-pages-posix
    glibcInfo # Provides C standard library documentation
  ]
