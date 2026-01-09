# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./clamav.nix
      (import "${home-manager}/nixos")
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.miguel = import ./home.nix;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    allowedTCPPortRanges = [ ];
    allowedUDPPortRanges = [ ];

    logRefusedConnections = false;
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.seatd.enable = true;
  # programs.dwl = {
  #   enable = true;
  #   package = pkgs.dwl.overrideAttrs (oldAttrs: {
  #     nativeBuildInputs = with pkgs; [
  #       installShellFiles
  #       pkg-config
  #       wayland-scanner
  #     ];
  #     buildInputs = with pkgs; [
  #       libinput
  #       xorg.libxcb
  #       libxkbcommon
  #       pixman
  #       wayland
  #       wayland-protocols
  #       xorg.libX11
  #       xorg.xcbutilwm
  #       pkgs.wlroots_0_19
  #       libdrm
  #     ];
  #     enable = true;
  #     src = ./config/dwl;
  #     __structuredAttrs = true;
  #     makeFlags = [
  #       "CC=clang"
  #       "PKG_CONFIG=${pkgs.clangStdenv.cc.targetPrefix}pkg-config"
  #       "WAYLAND_SCANNER=wayland-scanner"
  #       "PREFIX=$(out)"
  #       "MANDIR=$(man)/share/man"
  #       ''XWAYLAND="-DXWAYLAND"''
  #       ''XLIBS="xcb xcb-icccm"''
  #     ];
  #   });
  # };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses; # Best for terminal-heavy workflows
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;
  programs.neovim = {
    defaultEditor = true;
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.miguel = {
    isNormalUser = true;
    description = "Miguel Peixoto Portela Bispo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; import ./packages.nix { inherit pkgs; };
};

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
    nerd-fonts.arimo
  ];
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];




systemd.services.my-custom-script = {
  description = "Runs a custom command every 30 minutes";
  script = ./script/remenber-water.sh;
  # Optional: defines the user the script runs as
  serviceConfig = {
    User = "your-username";
    Type = "oneshot";
  };
};

systemd.timers.my-custom-script-timer = {
  description = "Timer for my custom script";
  # Ensures the service starts when the timer is activated
  wantedBy = [ "timers.target" ];
  # Activates the corresponding service file
  unit = "my-custom-script.service";
  # Sets the schedule (every 30 minutes)
  timerConfig = {
    OnCalendar = "*:0/30:0";
    # Ensures the job runs shortly after boot if the time has passed
    Persistent = true;
  };
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  programs.gamemode.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; # Did you read the comment?

}
