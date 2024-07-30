{ config, pkgs, ... }:
{
  services.mealie = {
    enable = true;
    package = pkgs.unstable.mealie;
  };

  # move data to tank
  fileSystems."/var/lib/private/mealie" = {
    device = "/mnt/tank/services/mealie";
    options = [
      "bind"
      "x-systemd.requires=zfs-mount.service"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    config.services.mealie.port
  ];
}
