{ pkgs, config, ... }:
{
  programs.vim = {
    enable = true;
    extraConfig = ''
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set ignorecase
      set history=1000
      set wildmenu
      set relativenumber
      set clipboard+=unnamedplus
      set noswapfile
      set cmdheight=2
      set spell
      set spelllang=en_us
    '';
  };
}
