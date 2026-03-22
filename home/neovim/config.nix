{pkgs, lib, ...}: let
  importFilesIn = dir: 
    lib.mapAttrs 
    (name: _: builtins.readFile (dir + "/${name}")) 
    (builtins.readDir dir);

  plugins = importFilesIn ./lua/plugins;
  main = builtins.readFile ./lua/main.lua;
  luaFiles = builtins.attrValues plugins ++ [main];
  luaConfig = builtins.concatStringsSep "\n" luaFiles;
in{
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
    extraLuaConfig = luaConfig;
  };
}
