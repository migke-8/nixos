{ pkgs, ... }: {
  virtualisation.vmware.host.enable = true;
  system.stateVersion = "26.05"; # Did you read the comment?
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
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
}
