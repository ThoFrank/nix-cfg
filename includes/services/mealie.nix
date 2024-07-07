{ config, pkgs, ... }:
{
  services.mealie = {
    enable = true;
    package = pkgs.unstable.mealie;
  };

  # move data to tank
  fileSystems."/var/lib/private/mealie" = {
    device = "/mnt/tank/services/mealie";
    options = ["bind"];
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];
}
