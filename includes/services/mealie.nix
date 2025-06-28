{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.mealie = {
    image = "ghcr.io/mealie-recipes/mealie:v2.8.0";
    ports = ["127.0.0.1:${toString config.services.mealie.port}:${toString config.services.mealie.port}"];
    volumes = [
      "/mnt/tank/services/mealie/:/app/data/"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];

  services.nginx.virtualHosts."rezepte.franks-im-web.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.mealie.port}";
    };
  };
}
