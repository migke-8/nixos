args@{ inputs, pkgs, lib, ... }:
let
  usersPath = ./modules/users;
  getFolders = path:
    let
      entries = builtins.readDir path;
    in
    builtins.attrNames (
      lib.filterAttrs
        (_: type: type == "directory")
        entries
    );
  userFolders = getFolders usersPath;

  getUserFile = fileName: args:
    builtins.listToAttrs (
      map
        (folder: {
          name = folder;
          value =
            if args != null then
              import (usersPath + "/${folder}/${fileName}") args
            else
              import (usersPath + "/${folder}/${fileName}");
        })
        userFolders
    );

  sysUsers = getUserFile "user.nix" args;
  houses = getUserFile "home/user-home.nix" null;
  systemModules = builtins.filter
    (path:
      lib.hasSuffix "default.nix" (builtins.toString path)
      && !(lib.hasInfix "/users/" (builtins.toString path))
    )
    (lib.fileset.toList ./modules);
in
{
  imports = [ ./hardware-configuration.nix ] ++ systemModules;

  # NixOS users
  users.users = sysUsers;

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    sharedModules = [
      inputs.nixvim.homeModules.nixvim
    ];
    users = houses;
  };

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # Localization
  time.timeZone = "America/Recife";
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

  # Desktop
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  console.keyMap = "br-abnt2";
}
