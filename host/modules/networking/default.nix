{...}: {
  networking.networkmanager.enable = true;

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.insertNameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565];
    allowedTCPPortRanges = [];
    allowedUDPPortRanges = [];
    logRefusedConnections = true;
  };

  networking.hostName = "nixos";
}
