{ config, pkgs, ... }:
{
  services.plex = {
    enable = true;
    package = pkgs.unstable.plex;
    openFirewall = true;
    };
}
