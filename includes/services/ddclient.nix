{ config, pkgs, ... }:
{
  services.ddclient = {
    enable = true;
    protocol = "dyndns2";
    use = "web, web=checkip.spdyn.de";
    server = "update.spdyn.de";
    ssl = true;
    username = "seifar98@gmail.com";
    passwordFile = "/home/thomas/src/nix-stuff/includes/services/password";
    domains = [ "tfrank.spdns.org" "frankcloud.firewall-gateway.com" ];
  };
  
  # container for brebeck.online
  containers."brebeckOnline" = {
    autoStart = true;
    ephemeral = true;
    bindMounts = {
      "/.secret/brebeck.ddclient.pass" = {
        hostPath = "/.secret/brebeck.ddclient.pass";
        isReadOnly = false;
      };
    };
    config = {pkgs, ...}: {
      system.stateVersion = "22.11";
      networking.networkmanager.enable = true;
      services.ddclient = {
        enable = true;
        protocol = "namecheap";
        use = "web, web=dynamicdns.park-your-domain.com/getip";
        server = "dynamicdns.park-your-domain.com";
        ssl = true;
        username = "brebeck.online";
        passwordFile = "/.secret/brebeck.ddclient.pass";
        domains = [ "@" ];
      };
    };
  };
}
