{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";
    settings = [
      {
        "height" = 40;
        "spacing" = 0;
        "modules-left" = ["sway/workspaces" "sway/mode"];
        "modules-center" = ["group/center"];
        "modules-right" = [
          "network"
          "clock"
          "temperature"
          "cpu"
          "memory"
          "pulseaudio"
          "battery"
        ];
        "group/center" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 350;
            "children-class" = "on-center";
            "transition-left-to-right" = true;
            "click-to-reveal" = true;
          };
          "modules" = [
            "custom/logo"
            "custom/apps"
            "custom/suspend"
            "custom/reboot"
            "custom/shutdown"
          ];
        };
        "custom/logo" = {
          "format" = "   ";
          "tooltip" = false;
        };
        "custom/apps" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "rofi -show drun";
        };
        "custom/suspend" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "susp";
        };
        "custom/reboot" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "reboot";
        };
        "custom/shutdown" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "shutdown now";
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%H:%M:%OS} ";
          "tooltip-format" = "{}";
        };
        "temperature" = {
          "interval" = 1;
          "critical-threshold" = 80;
          "format-critical" = "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = ["" "" ""];
          "hwmon-path-abs" = "/sys/devices/platform/coretemp.0/hwmon";
          "input-filename" = "temp2_input";
          "tooltip" = false;
        };
        "cpu" = {
          "format" = "{usage}%  ";
          "interval" = 1;
          "tooltip" = true;
        };
        "memory" = {
          "format" = "{}%  ";
          "interval" = 1;
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "interval" = 1;
          "format" = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}%  {icon}";
          "format-plugged" = "{capacity}%  {icon}";
          "format-icons" = ["" "" "" "" ""];
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{volume}%  ";
          "format-muted" = "{volume}%  ";
          "format-source" = "{volume}%  ";
          "format-source-muted" = "{volume}%  ";
          "on-click" = "amixer set Master toggle";
          "tooltip" = false;
        };
        "network" = {
          "format-wifi" = "{signalStrength}%  ";
          "format-ethernet" = "{ipaddr}/{cidr} \uef44";
          "tooltip-format" = "network = {essid}";
          "format-linked" = "{ifname} (No IP) \udb80\udf37";
          "format-disconnected" = "Disconnected \uf071";
          "interval" = 1;
        };
      }
    ];
    style = ''
      * {
        font-family: ArimoNerdFontPropo, monospace;
      }

      window#waybar {
        font-size: 18px;
        background-color: rgba(39, 40, 34, 0.7);
        color: rgba(253, 255, 241, 1);
      }

      #custom-logo,
      #custom-apps,
      #custom-suspend,
      #custom-reboot,
      #custom-shutdown {
        padding: 0.75rem 1rem;
        transition-property: background-color;
        transition-duration: 0.4s;
        background-position: center;
        background-repeat: no-repeat;
      }

      #custom-apps,
      #custom-suspend,
      #custom-reboot,
      #custom-shutdown {
        background-size: 60%;
      }

      #custom-logo {
        background-image: url("${./images/NixOS.svg}");
        background-size: 100%;
      }

      #custom-apps {
        background-image: url("${./images/apps-svgrepo-com.svg}");
      }

      #custom-suspend {
        background-image: url("${./images/snooze-svgrepo-com.svg}");
      }

      #custom-reboot {
        background-image: url("${./images/arrow-cycle-svgrepo-com.svg}");
      }

      #custom-shutdown {
        background-image: url("${./images/on-off-svgrepo-com.svg}");
      }

      #custom-logo:hover {
        background-color: rgba(253, 255, 241, 0.2);
      }
      #custom-apps:hover,
      #custom-suspend:hover,
      #custom-reboot:hover,
      #custom-shutdown:hover {
        background-color: rgba(253, 255, 241, 0.4);
      }

      #workspaces button {
        text-shadow: none;
        padding: 0.5rem 0.75rem;
        border-radius: 0;
        transition-property: background-color;
        transition-duration: 0.4s;
        background: rgba(39, 40, 34, 0.6);
        color: rgba(253, 255, 241, 1);
        border: none;
        outline: none;
        box-shadow: none;
      }

      #workspaces button:not(.urgent):hover {
        background: rgba(253, 255, 241, 0.4);
        box-shadow: none;
        font-weight: bold;
      }

      #workspaces button.focused {
        background: rgba(253, 255, 241, 0.4);
        border-bottom: 3px solid rgba(253, 255, 241, 1);
      }

      #workspaces button.urgent {
        color: rgba(249, 38, 114, 1);
        border-color: rgba(249, 38, 114, 1);
      }

      #workspaces button.urgent:hover {
        background: rgba(249, 38, 114, 0.4);
        font-weight: bold;
      }

      #window,
      #workspaces {
        margin: 0 2rem;
      }

      .modules-left>widget:first-child>#workspaces {
        margin-left: 0;
      }

      .modules-right>widget:last-child>#workspaces {
        margin-right: 0;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #scratchpad,
      #temperature {
        transition-property: background;
        transition-duration: 0.4s;
        padding: 0.5rem 0.75rem 0.5rem 0.75rem;
        color: rgba(253, 255, 241, 1);
        border-bottom: 3px solid white;
      }

      #clock:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #network:hover,
      #pulseaudio:hover,
      #custom-media:hover,
      #tray:hover,
      #mode:hover,
      #temperature:hover,
      #scratchpad:hover {
        font-weight: bold;
        background-color: rgba(253, 255, 241, 0.4);
      }

      #battery.critical:not(.charging) {
        color: rgba(249, 38, 114, 1);
        border-color: rgba(249, 38, 114, 1);
      }

      #battery.warning:not(.charging) {
        color: rgba(230, 219, 116, 1);
        border-color: rgba(230, 219, 116, 1);
      }

      #battery.charging {
        color: rgba(166, 226, 46, 1);
        border-color: rgba(166, 226, 46, 1);
      }

      #battery.critical:not(.charging):hover {
        background: rgba(249, 38, 114, 0.4);
      }

      #battery.warning:not(.charging):hover {
        background: rgba(230, 219, 116, 0.4);
      }

      #battery.charging:hover {
        background: rgba(166, 226, 46, 0.4);
      }

      #battery.plugged:hover {
        background: rgba(166, 226, 46, 0.4);
      }
    '';
  };
}
