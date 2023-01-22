{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      #influxdb = {
      #  enable = true;
      #  port = 8086;
      #};
    };
    scrapeConfigs = [
      {
        job_name = "localhost";
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
    ];
  };
}
