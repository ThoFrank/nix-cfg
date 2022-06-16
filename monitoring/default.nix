{ config, pkgs, ... }:
{
  imports = [
    ./grafana.nix
    ./influxdb.nix
    ./prometheus.nix
    ./telegraf.nix
  ];
}
