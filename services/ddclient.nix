{ config, pkgs, ... }:
{
  services.ddclient = {
    enable = true;
    protocol = "dyndns2";
    use = "web, web=checkip.spdyn.de";
    server = "update.spdyn.de";
    ssl = true;
    username = "seifar98@gmail.com";
    passwordFile = "/home/thomas/src/nix-stuff/services/password";
    domains = [ "tfrank.spdns.org" ];
  };
}
