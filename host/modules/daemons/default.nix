{ pkgs, ... }: {
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };
  systemd.services = {
    # enabled
    smartd.enable = true;
    # disabled
    cups.enable = false;
    docker.enable = false;
    smbd.enable = false;
    postfix.enable = false;
    mdmonitor.enable = false;
  };
  systemd.timers = {
    fstrim.enable = true;
  };
  systemd.user.services.reminder-timer = {
    description = "Send a notification reminder";

    serviceConfig = {
      Type = "oneshot";

      ExecStart = pkgs.writeShellScript "drink-water-reminder" ''
        ${pkgs.libnotify}/bin/notify-send \
          "Drink water!" \
          "Just remembering..." \
          -i alarm-clock
      '';
    };
  };
  systemd.user.timers.reminder-timer = {
    description = "Run the reminder for drinking water";

    timerConfig = {
      OnCalendar = "*:0/15";
      Persistent = true;
    };

    wantedBy = [ "timers.target" ];
  };
  services.seatd.enable = true;
  services.openssh.enable = true;
}
