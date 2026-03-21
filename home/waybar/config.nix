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
    styles = ./styles.css;
  };
}
