{...}: {
  services.gammastep = {
    enable = true;
    temperature = {
      day = 6000;
      night = 5200;
    };
    brightness = {
      day = 1.0;
      night = 1.0;
    };
    provider = "manual";
    latitude = -8.04;
    longitude = -34.55;
  };
}
