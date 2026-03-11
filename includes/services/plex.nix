{ config, pkgs, ... }:
{
  services.plex = {
    enable = true;
    package = pkgs.plex;
    openFirewall = true;
    };
}
