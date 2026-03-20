{pkgs, ...}: {
  home.packages = with pkgs; [
    swaybg
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_options = "altwin:swap_lalt_lwin";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          drag_lock = "disabled";
          dwt = "disabled";
        };
      };
      output = {
        "*" = {
          bg = "${./images/ivyssaur.png} fill";
        };
      };
      font = "ArimoNerdFontPropo 15";
      titlebar_border_thickness = 0;
      titlebar_padding = 2;
      title_align = "center";
      bars = [];
      gaps.inner = 10;
    };
  };
}
