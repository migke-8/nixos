{pkgs}: let
in
  with pkgs; [
    # Build tools
    mill
    scala-cli
    cmake
    gnumake
    # Languages/runtimes
    nasm
    scala
    bun
    nodejs
    clang
    gcc
    # Libraries
    musl
    # Debuggers
    gdb
    #databases
    sqld
    # editors
    zed-editor
    # bash-language-server
    # nodePackages.vscode-langservers-extracted
    # typescript-language-server
    # vscode-css-languageserver
    # jdt-language-server
    # clang-tools
    # svelte-language-server
    # # editors
    # jetbrains.idea-community
  ]
