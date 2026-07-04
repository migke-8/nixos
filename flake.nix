{
	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs/nixos-unstable";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
		};
		nixvim = {
			url = "github:nix-community/nixvim";
		};
	};

  outputs = inputs@{
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
      	inherit inputs;
      };
      modules = [
      # locals
        ./host/configuration.nix
{
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.extraSpecialArgs = {
		inherit inputs;
	};
	home-manager.users.miguel= import ./host/home.nix;
}
	# externals
	home-manager.nixosModules.home-manager
      ];
    };
  };
}
