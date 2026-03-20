{...}: {
  wayland.windowManager.sway = {
    input = {
      "type:keyboard" = {
        xkb_layout = "br";
        xkb_variant = "abnt2";
      };
    };
  };
}
