{
  inputs = {
    polymc.url = "github:PolyMC/PolyMC/develop";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = {nixpkgs, polymc, home-manager-stable, home-manager-unstable, ...} @ inputs: {
    nixosConfigurations = {
    nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit polymc;};
      modules = [
        ./configuration.nix
        home-manager-stable.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.miguel = import ./home.nix;
        }
      ];
    };
    };
  };
}
