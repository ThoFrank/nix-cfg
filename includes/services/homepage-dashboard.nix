{ config, pkgs, lib, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
    ];
    services = [
      {
        "Local" = [
          {
            "Nextcloud" = {
              href = "https://cloud.franks-im-web.de";
              description = "personal Nextcloud instance";
              icon = "nextcloud";
            };
          }{
            "Mealie" = {
              href = "https://rezepte.franks-im-web.de";
              description = "personal cookbook";
              icon = "mealie";
            };
          }{
            "Home Assistant" = {
              href = "http://192.168.2.2:${builtins.toString config.services.home-assistant.config.http.server_port}";
              description = "Open source home automation";
              icon = "home-assistant";
            };
          }{
            "Zigbee2Mqtt" = {
              href = "http://192.168.2.2:${builtins.toString config.services.zigbee2mqtt.settings.frontend.port}";
              description = "Zigbee to MQTT bridge";
              icon = "zigbee2mqtt";
            };
          }{
            "Plex" = {
              href = "https://app.plex.tv";
              description = "local movie database";
              icon = "plex";
            };
          }
        ] ++ lib.optional config.services.psv-registration-wa.enable 
          {
            "PSV Registration WA" = {
              href = "https://${builtins.head config.services.psv-registration-wa.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ++ lib.optional config.services.psv-registration-feld.enable 
          {
            "PSV Registration Feld" = {
              href = "https://${builtins.head config.services.psv-registration-feld.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ++ lib.optional config.services.psv-registration-indoor.enable 
          {
            "PSV Registration Indoor" = {
              href = "https://${builtins.head config.services.psv-registration-indoor.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ++ lib.optional config.services.psv-registration-vm-halle.enable 
          {
            "PSV Registration VM Halle" = {
              href = "https://${builtins.head config.services.psv-registration-vm-halle.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          };
      }{
        "Remote" = [
          {
            "Router" = {
              href = "http://192.168.2.1";
              description = "Telekom router web interface";
              icon = "telekom";
            };
          }{
            "Octoprint" = {
              href = "http://192.168.2.80:5000";
              description = "Web interface for 3D printer";
              icon = "octoprint";
            };
          }
        ];
      }
    ];
  };
}
