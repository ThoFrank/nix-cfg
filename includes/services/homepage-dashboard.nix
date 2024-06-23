{ config, pkgs, ... }:
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
            "Home Assistant" = {
              href = "http://192.168.2.2:8123";
              description = "Open source home automation";
              icon = "home-assistant";
            };
          }{
            "Plex" = {
              href = "https://app.plex.tv";
              description = "local movie database";
              icon = "plex";
            };
          }
        ] ++ (if config.services.psv-registration-wa.enable then [
          {
            "PSV Registration WA" = {
              href = "https://${builtins.head config.services.psv-registration-wa.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ] else [])
        ++ (if config.services.psv-registration-feld.enable then [
          {
            "PSV Registration Feld" = {
              href = "https://${builtins.head config.services.psv-registration-feld.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ] else [])
        ++ (if config.services.psv-registration-indoor.enable then [
          {
            "PSV Registration Indoor" = {
              href = "https://${builtins.head config.services.psv-registration-indoor.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ] else [])
        ++ (if config.services.psv-registration-vm-halle.enable then [
          {
            "PSV Registration VM Halle" = {
              href = "https://${builtins.head config.services.psv-registration-vm-halle.nginx.hostNames}";
              icon = "mdi-bullseye-arrow";
            };
          }
        ] else []);
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
