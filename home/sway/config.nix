{pkgs, ...}: {
  imports = [
    ./keybindings.nix
  ];
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
      fonts = ["ArimoNerdFontPropo 15"];
      window = {
        titlebar = false;
        border = 0;
      };
      bars = [];
      gaps.inner = 10;
    };
  };
}
