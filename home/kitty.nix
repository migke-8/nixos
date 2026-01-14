{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = ''

: Fonts {{{
font_family      MononokiNerdFont
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 14.0
: }}}
    '';
  };

}


