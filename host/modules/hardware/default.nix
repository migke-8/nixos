{ ... }: {

  # audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = false;
      disableWhileTyping = false;
    };
  };
  # extra
  services.udev.extraRules = ''
    KERNEL=="sda", SUBSYSTEM=="block", OWNER="root", GROUP="disk", MODE="0660"
  '';
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.fwupd.enable = true;
  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  swapDevices = [{
    device = "/dev/disk/by-uuid/f257038d-7e42-4ec4-9ff5-fa7d4c3e43d9";
  }];
}
