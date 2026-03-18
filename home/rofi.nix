{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    extraConfig = {
      display-drun = "apps";
      modes = "drun,run";
      font = "ArimoNerdFontPropo 15";
      show-icons = true;
      fixed-num-lines = true;
      terminal = "foot";
      drun-display-format = "{icon} {name}";
      kb-move-char-back = "Shift+Left";
      kb-move-char-forward = "Shift+Right";
      kb-mode-next = "Control+Tab";
      kb-mode-previous = "Control+ISO_Left_Tab";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        selected-normal-foreground = mkLiteral "rgba(253, 255, 241, 1)";
        normal-spacing = mkLiteral "0";
        foreground = mkLiteral "rgba(253, 255, 241, 1)";
        normal-foreground = mkLiteral "rgba(253, 255, 241, 1)";
        alternate-normal-background = mkLiteral "transparent";
        selected-urgent-foreground = mkLiteral "rgba(249, 38, 114, 1)";
        urgent-foreground = mkLiteral "rgba(249, 38, 114, 1)";
        alternate-urgent-background = "transparent";
        active-foreground = mkLiteral "rgba(249, 38, 114, 1)";
        selected-active-foreground = mkLiteral "rgba(253, 255, 241, 1)";
        alternate-active-background = "transparent";
        background = mkLiteral "transparent";
        bordercolor = mkLiteral "transparent";
        alternate-normal-foreground = mkLiteral "rgba(253, 255, 241, 1)";
        normal-background = mkLiteral "transparent";
        lightfg = mkLiteral "transparent";
        selected-normal-background = mkLiteral "transparent";
        border-color = mkLiteral "transparent";
        spacing = mkLiteral "transparent";
        urgent-background = mkLiteral "transparent";
        separatorcolor = mkLiteral "transparent";
        selected-urgent-background = mkLiteral "transparent";
        alternate-urgent-foreground = mkLiteral "rgba(249, 38, 114, 1)";
        background-color = mkLiteral "transparent";
        alternate-active-foreground = mkLiteral "rgba(253, 255, 241, 1)";
        active-background = mkLiteral "transparent";
        selected-active-background = mkLiteral "rgba(249, 38, 114, 1)";
      };
      window = {
        font-size = mkLiteral "4em";
        width = mkLiteral "35em";
        height = mkLiteral "35em";
        background-color = mkLiteral "rgba(39, 40, 34, 0.7)";
        border = mkLiteral "none";
        padding = mkLiteral "0";
      };
      mainbox = {
        children = mkLiteral "[inputbar, listview]";
        padding = mkLiteral "0";
      };
      inputbar = {
        border-color = mkLiteral "rgba(253, 255, 241, 1)";
        children = mkLiteral "[prompt, textbox-prompt-colon, entry]";
        position = mkLiteral "center";
        expand = false;
        padding = mkLiteral "1em";
        border = mkLiteral "0 solid 0 solid 0.2em solid";
      };
      prompt = {
        font = "ArimoNerdFontPropo bold 24";
      };
      textbox-prompt-colon = {
        font ="ArimoNerdFontPropo bold 24";
      };
      entry = {
        font = "ArimoNerdFontPropo 24";
      };
      element-icon = {
        size = mkLiteral "125px";
        horizontal-align = mkLiteral "0.5";
      };
      element = {
        width = mkLiteral "200px";
        height = mkLiteral "200px";
        orientation = mkLiteral "vertical";
        padding = mkLiteral "10px 10px 13px 10px";
      };
      "element selected.normal" = {
        font = "ArimoNerdFontPropo Bold 15";
        background-color = mkLiteral "rgba(253, 255, 241, 0.4)";
      };
      element-text = {
        font = mkLiteral "inherit";
        horizontal-align = mkLiteral "0.5";
        highlight = mkLiteral "bold #ae81ff";
      };
      "element-text selected.normal" = {
        width = mkLiteral "200px";
        font = "ArimoPropoNerdFont 16px";
      };
      listview = {
        flow = mkLiteral "horizontal";
        columns = 4;
        lines = 4;
        scrollbar = false;
        fixed-height = false;
      };
    };
  };
}
