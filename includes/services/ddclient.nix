{ config, pkgs, ... }:
{
  services.inadyn = {
    enable = true;
    settings.provider."default@spdyn.de" = {
      ssl = true;
      username = "seifar98@gmail.com";
      hostname = "tfrank.spdns.org";
      include = "/.secret/spdyn";
    };
    settings.provider."default@spdyn.de:2" = {
      ssl = true;
      username = "seifar98@gmail.com";
      hostname = "frankcloud.firewall-gateway.com";
      include = "/.secret/spdyn";
    };
  };
}
