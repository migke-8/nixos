{ pkgs, config, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        font = "MononokiNerdFontMono:size=15";
        "box-drawings-uses-font-glyphs" = "yes";
        "selection-target" = "both";
      };
      cursor = {
        style = "underline";
        "unfocused-style" = "none";
        "underline-thickness" = "2px";
        blink = true;
      };
      colors = {
        background="272822";
        foreground="fdfff1";
        regular0="6e7066";
        regular1="f92672";
        regular2="a6e12e";
        regular3="e2db74";
        regular4="fb9027";
        regular5="ae81ff";
        regular6="66d9ef";
        regular7="fdfff1";
        bright0="86887b";
        bright1="FF6188";
        bright2="A9DC76";
        bright3="FFD866";
        bright4="FC9867";
        bright5="AB9DF2";
        bright6="78DCE8";
        bright7="FFFFFF";
        alpha = 0.9;
      };
    };
  };
}
