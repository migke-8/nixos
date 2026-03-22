{pkgs, ...}: {
  programs.neovim = {
    defaultEditor = true;
    package = pkgs.unstable.neovim;
    enable = true;
    plugins = with pkgs.unstable.vimPlugins; [
      monokai-pro-nvim
      vim-mustache-handlebars
      none-ls-nvim
      telescope-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip
      oil-nvim
      nvim-metals
      lualine-nvim
      render-markdown-nvim
      nvim-lspconfig
      nvim-treesitter.withPlugins
      (p: [
        p.nix
      ])
      nvim-cmp
    ];
    extraPackages = with pkgs.unstable; [
      # formatters
      stylua
      black
      nodePackages.prettier
      shfmt
      alejandra
      # lsp
      nixd
      lemminx
      luajitPackages.lua-lsp
      bash-language-server
      nodePackages.vscode-langservers-extracted
      typescript-language-server
      vscode-css-languageserver
      jdt-language-server
      java-language-server
      clang-tools
      svelte-language-server
      metals
      coursier
      scala-cli
      # extra
      ripgrep
      tree-sitter
    ];
    extraLuaConfig = builtins.readFile ./lua/main.lua;
  };
}
