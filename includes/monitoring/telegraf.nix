{ config, pkgs, ... }:
{
  services.telegraf = {
    #package = pkgs.telegraf.overrideAttrs (oldAttrs: {
    #  propagatedBuildInputs = [pkgs.iputils];
    #});
    enable = true;
    extraConfig = {
      inputs.ping = {
        interval = "60s";
        urls = [ "amazon.com" "github.com" "192.168.100.1" "192.168.1.1" ];
        count = 4;
        ping_interval = 1.1;
        timeout = 2.1;
        method = "native"; # otherwise it would try to use ping command and fail in finding it
      };
      inputs.net = {
        interfaces = [ "enp2s0" ];
      };
      outputs.influxdb = {
        urls = [ "http://127.0.0.1:8086" ];
        database = "telegraf";
      };
    };
  };
}
