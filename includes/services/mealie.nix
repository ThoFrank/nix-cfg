{ config, pkgs, ... }:
let
  url = "rezepte.franks-im-web.de";
in {
  virtualisation.oci-containers.containers.mealie = {
    image = "ghcr.io/mealie-recipes/mealie:v3.0.2";
    ports = ["127.0.0.1:${toString config.services.mealie.port}:${toString config.services.mealie.port}"];
    volumes = [
      "/mnt/tank/services/mealie/:/app/data/"
    ];
    environment = {
      BASE_URL = "https://${url}";
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];

  services.nginx.virtualHosts."${url}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.mealie.port}";
    };
  };
}
