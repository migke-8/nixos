{
  pkgs,
  lib,
  ...
}: {
  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      vim-mustache-handlebars
      monokai-pro-nvim
      none-ls-nvim
      telescope-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip
      rustaceanvim
      oil-nvim
      nvim-metals
      lualine-nvim
      render-markdown-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-dap
      nvim-dap-ui
      crates-nvim
      nvim-jdtls
    ];
  };
}
