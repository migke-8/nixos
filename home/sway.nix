{...}: {
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
      bars = [];
    };
  };
}
