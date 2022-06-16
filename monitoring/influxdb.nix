{ config, pkgs, ... }:
{
  services.influxdb = {
    enable = true;
    #extraConfig.http.bind-address =  ":${toString config.services.prometheus.exporters.influxdb.port}";
    #extraConfig.meta.bind-address = ":${toString config.services.prometheus.exporters.influxdb.port}";
  };
}
