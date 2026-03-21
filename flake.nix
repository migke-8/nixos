{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    polymc.url = "github:PolyMC/PolyMC/develop";
  };

  outputs = {
    self,
    polymc,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager-stable,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit polymc;
      };
      modules = [
        ./configuration.nix
        home-manager-stable.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.system;
                config.allowUnfree = true;
              };
            })
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.miguel = import ./home.nix;
        }
      ];
    };
  };
}
