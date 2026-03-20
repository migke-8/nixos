{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_variant = "abnt2";
        };
      };
    };
  };
}
