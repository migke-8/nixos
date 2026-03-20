{...}: let
  mod = "Mod4";
in {
  wayland.windowManagers.sway.config.keybindings = {
    modifier = mod;
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };
}
