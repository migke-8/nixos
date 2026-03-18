{
  pkgs,
  config,
  ...
}: {
  systemd.user.services.ringboard = {
    Unit = {
      Description = "Ringboard clipboard history server";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.ringboard}/bin/ringboard";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
