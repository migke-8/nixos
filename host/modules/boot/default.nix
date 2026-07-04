{ pkgs, ...}: {
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.plymouth.enable = true;
	boot.plymouth.theme = "bgrt";
	boot.loader.systemd-boot.consoleMode = "max";
	boot.plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
	boot.kernelParams = [
		"fsck.mode=force"
			"fsck.repair=yes"
			"quiet"
			"splash"
			"intel_iommu=on"
			"iommu=pt"
			"transparent_hugepage=never"
			"mptspi"
			"vmw_balloon"
			"vmw_pvscsi"
			"vsock"
			"ahci"
			"sd_mod"
	];
       }
