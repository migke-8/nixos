{ config, pkgs, ... }:
let
  desiredFlatpaks = [
    "org.duckstation.DuckStation"
    "org.vinegarhq.Sober"
  ];

  desiredFlatpaksShell =
    builtins.concatStringsSep " " (map (x: "'${x}'") desiredFlatpaks);
in
{
  services.flatpak.enable = true;

  system.userActivationScripts.flatpakManagement = {
    text = ''
      set -e

      FLATPAK="${pkgs.flatpak}/bin/flatpak"

      echo "Configurando Flathub..."

      "$FLATPAK" remote-add --if-not-exists \
        flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo

      echo "Instalando Flatpaks desejados..."

      for app in ${desiredFlatpaksShell}; do
        echo "Garantindo que $app esteja instalado..."
        "$FLATPAK" install -y flathub "$app"
      done

      echo "Removendo runtimes não utilizados..."

      "$FLATPAK" uninstall --unused -y || true

      echo "Atualizando Flatpaks..."

      "$FLATPAK" update -y

      echo "Flatpaks configurados."
    '';
  };
}
