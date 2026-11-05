{ pkgs, inputs, ... }: {
  isNormalUser = true;
  description = "Miguel Peixoto Portela Bispo";
  extraGroups = [
    "networkmanager"
    "wheel"
    "libvirtd"
    "kvm"
    "disk"
  ];
  packages =
    import ./packages/packages.nix { inherit pkgs; }
    ++ import ./packages/coding-packages.nix { inherit pkgs; inherit inputs; }
    ++ import ./packages/cli-tui-packages.nix { inherit pkgs; }
    ++ import ./packages/rice-packages.nix { inherit pkgs; };
  shell = pkgs.zsh;
}
