{ config, pkgs, lib, ... }:

{
  #############################
  ## ClamAV Daemon + Updater ##
  #############################

  services.clamav = {
    daemon = {
      enable = true;

      settings = {
        LogSyslog = true;
        LogRotate = true;
        MaxFileSize = "4G";
        StreamMaxLength = "250M";

        # Must exist
        TemporaryDirectory = "/var/lib/clamav/tmp";
      };
    };

    updater = {
      enable = true;

      # Freshclam settings
      settings = {
        UpdateLogFile = "/var/log/clamav/freshclam.log";

        # FIXED: ClamAV 1.2+ removed CheckInterval
        # Use "Checks" instead (max checks per day)
        Checks = 12;
      };
    };
  };

  #############################
  ## Directories (tmpfiles) ###
  #############################

  systemd.tmpfiles.rules = [
    "d /var/log/clamav 0755 clamav clamav -"
    "f /var/log/clamav/freshclam.log 0774 clamav clamav -"
    "d /var/lib/clamav/quarantine 0760 clamav clamav -"
    "d /var/lib/clamav/tmp 0755 clamav clamav -"
  ];

  ###########################
  ## Scheduled Daily Scan  ##
  ###########################

  systemd.services.clamav-scan = {
    description = "Daily ClamAV System Scan";
    after = [ "network.target" "clamav-daemon.service" ];
    wants = [ "clamav-daemon.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        /run/current-system/sw/bin/clamdscan --fdpass --infected \
          --move=/var/lib/clamav/quarantine /
      '';
    };
  };

  ################################
  ## Realtime Scanner (Inotify) ##
  ################################

  environment.systemPackages = [
    pkgs.inotify-tools
  ];

  systemd.services.clamav-realtime = {
    enable = true;
    description = "Realtime ClamAV Antivirus Scanner";

    after = [ "clamav-daemon.service" ];
    wants = [ "clamav-daemon.service" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 2;

      ExecStart = ''
        ${pkgs.inotify-tools}/bin/inotifywait -m -e create,modify /home \
        | while read -r dir action file; do
            echo "Scanning: $dir$file" | systemd-cat -t clamav-realtime
            /run/current-system/sw/bin/clamdscan --fdpass "$dir$file" \
              --move=/var/lib/clamav/quarantine
          done
      '';
    };
  };
}
