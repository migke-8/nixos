# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  polymc,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./clamav.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.loader.systemd-boot.consoleMode = "max";
  boot.plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  boot.kernelParams = [
    "quiet"
    "splash"
    "intel_iommu=on"
    "iommu=pt"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565];
    allowedTCPPortRanges = [];
    allowedUDPPortRanges = [];
    logRefusedConnections = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Recife";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  services.libinput.enable = true;
  console.keyMap = "br-abnt2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.seatd.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
  programs.sway.enable = true;
  programs.chromium.enable = true;

  programs.zsh.enable = true;

  nixpkgs.overlays = [
    polymc.overlay
  ];

  users.users.miguel = {
    isNormalUser = true;
    description = "Miguel Peixoto Portela Bispo";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm"];
    packages =
      import ./packages/packages.nix {inherit pkgs;}
      ++ import ./packages/coding-packages.nix {inherit pkgs;}
      ++ import ./packages/cli-tui-packages.nix {inherit pkgs;}
      ++ import ./packages/rice-packages.nix {inherit pkgs;};
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 1. Define the systemd service
  systemd.user.services.reminder-timer = {
    description = "Send a notification reminder";
    serviceConfig = {
      Type = "oneshot";
      # ${pkgs.libnotify}/bin/notify-send ensures the tool is available
      # even if it's not installed system-wide.
      ExecStart = "${pkgs.libnotify}/bin/notify-send 'Drink water!' 'Just remembering...' -i alarm-clock";
    };
  };

  # 2. Define the timer (The 'Cron' part)
  systemd.user.timers.reminder-timer = {
    description = "Run the reminder for drinking water";
    timerConfig = {
      OnCalendar = "*:0/15:00";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  programs.gamemode.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05"; # Did you read the comment?
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = ["kvm-amd" "kvm-intel"];
  # virtualisation.libvirtd.qemu = {
  #   package = pkgs.qemu_kvm;
  #   runAsRoot = true;
  #   swtpm.enable = true;
  # };
  virtualisation.libvirtd = {
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true; # Tente mudar para true se estiver false
      swtpm.enable = true; # Necessário para Windows 11 (TPM)
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];
}
