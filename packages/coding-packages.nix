{pkgs}: let
in
  with pkgs; [
    # Build tools
    mill
    cmake
    gnumake
    # Languages/runtimes
    scala
    bun
    clang
    # Libraries
    musl
    # formatters
    alejandra
    stylua
    prettier
    # LSPs
    nixd
    lemminx
    luajitPackages.lua-lsp
    bash-language-server
    nodePackages.vscode-langservers-extracted
    typescript-language-server
    vscode-css-languageserver
    jdt-language-server
    clang-tools
    svelte-language-server
  ]
