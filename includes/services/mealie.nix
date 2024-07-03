{ config, pkgs, ... }:
{
  services.mealie = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];
}
