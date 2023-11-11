{ config, pkgs, ... }:
{
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      media_dir = [
        "V,/mnt/tank/Filme"
      ];
    };
  };
}
