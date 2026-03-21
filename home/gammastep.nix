{...}: {
  programs.gammastep = {
    enable = true;
    temp-day = 6000;
    temp-night = 5200;
    brightness-day = 1.0;
    brightness-night = 1.0;
    location-provider = "manual";
    lat = -8.04;
    lon = -34.55;
  };
}
