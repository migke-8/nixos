{pkgs}: let
in
  with pkgs; [
    # Build tools
    mill
    gnumake
    # Languages/runtimes
    nasm
    scala-next
    bun
    nodejs
    clang
    gcc
    graalvmPackages.graalvm-ce-musl
    # Libraries
    musl
    # Debuggers
    gdb
    #databases
    sqld
  ]
