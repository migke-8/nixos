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
      oil-nvim
      nvim-metals
      lualine-nvim
      render-markdown-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
  };
}
