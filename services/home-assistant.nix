{ config, pkgs, ... }:
{
  imports = [ ];
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      zha = {
        zigpy_config = {
          ikea_provider = true;
        };
      };
      homekit = {};
    };
  };
}
