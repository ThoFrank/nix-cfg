{ config, pkgs, ... }:
{
  # grafana configuration
  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
    provision = {
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "direct";
          url = "http://localhost:${toString config.services.prometheus.port}";
        }
      ];
    };
  };
}
