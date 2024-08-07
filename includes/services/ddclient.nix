{ config, pkgs, ... }:
{
  services.ddclient = {
    enable = true;
    protocol = "dyndns2";
    use = "web, web=ipify-ipv4";
    server = "update.spdyn.de";
    ssl = true;
    username = "seifar98@gmail.com";
    passwordFile = "/home/thomas/src/nix-stuff/includes/services/password";
    domains = [ "tfrank.spdns.org" "frankcloud.firewall-gateway.com" ];
  };
}
