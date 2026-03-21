{
  config,
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  term = "foot";
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      terminal = term;
      menu = "rofi -show drun | xargs swaymsg exec";

      # Basic Settings
      fonts = {
        names = ["ArimoNerdFontPropo"];
        size = 15.0;
      };

      window = {
        border = 2;
        titlebar = false;
      };

      # Colors (client.<class> <border> <bg> <text> <indicator> <child_border>)
      colors = {
        focused = {
          border = "#fdfff199";
          background = "#fdfff199";
          text = "#272822";
          indicator = "#fdfff1";
          childBorder = "#fdfff1";
        };
        unfocused = {
          border = "#27282299";
          background = "#27282299";
          text = "#fdfff1";
          indicator = "#27282299";
          childBorder = "#00000000";
        };
        focusedInactive = {
          border = "#27282299";
          background = "#27282299";
          text = "#fdfff1";
          indicator = "#27282299";
          childBorder = "#00000000";
        };
        urgent = {
          border = "#f9267299";
          background = "#f9267299";
          text = "#fdfff1";
          indicator = "#f9267299";
          childBorder = "#f9267293";
        };
      };

      # Output & Input
      output = {
        "*" = {bg = "${./images/ivyssaur.png} fill";};
      };

      input = {
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          drag_lock = "disabled";
          dwt = "disabled";
        };
        "type:keyboard" = {
          xkb_layout = "br";
          xkb_variant = "abnt2";
        };
      };

      # Keybindings
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${term}";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec rofi -show drun | xargs swaymsg exec";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+f" = "exec ${term} -- nnn";

        # Focus
        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        # Move
        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        # Custom Scripts & Multimedia
        "${mod}+Ctrl+${left}" = "exec ${./scripts/swapws.sh} Left";
        "${mod}+Ctrl+${right}" = "exec ${./scripts/swapws.sh} Right";
        "${mod}+Shift+t" = "exec ${./scripts/toggleidle.sh}";

        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "Print" = "exec grimshot savecopy area";
      };

      # Modes
      modes.resize = {
        "${left}" = "resize shrink width 10px";
        "${down}" = "resize grow height 10px";
        "${up}" = "resize shrink height 10px";
        "${right}" = "resize grow width 10px";
        "Return" = "mode default";
        "Escape" = "mode default";
      };

      # bars and gaps
      bars = [];
      gaps.inner = 10;

      # Startup Commands
      startup = [
        {command = "mako";}
        {command = "gammastep";}
        {command = "sway-audio-idle-inhibit";}
        {command = "ringboard-wayland";}
        {
          command = ''
            swayidle -w \
              timeout 300 'swaylock -f -c 000000' \
              timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep 'swaylock -f -c 000000'
          '';
        }
      ];

      # Window Rules
      window.commands = [
        {
          command = "inhibit_idle open";
          criteria = {app_id = "PCSX2.*";};
        }
        {
          command = "inhibit_idle open";
          criteria = {app_id = "duckstation";};
        }
        {
          command = "inhibit_idle open";
          criteria = {app_id = "PolyMC.*";};
        }
      ];
    };

    # Extra configuration that doesn't fit the helper options
    extraConfig = ''
      titlebar_border_thickness 0
      titlebar_padding 2
      title_align center
    '';
  };
}
