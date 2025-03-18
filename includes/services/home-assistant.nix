{ config, pkgs, ... }:
{
  imports = [ ];
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      http = {server_port = 8123;};
      zha = {
        zigpy_config = {
          ikea_provider = true;
        };
      };
      homekit = {
        port = 21063;
      };
      "automation ui" = "!include automations.yaml";
      switch = {
        platform = "flux";
        name = "Tageszeit Temperatur";
        lights = ["light.klotz" "light.pilz" "light.deckenlampe" "light.fakefenster"];
        start_time = "7:00";
        stop_time = "23:00";
        mode = "mired";
        disable_brightness_adjust = true;
        transition = 3;
        interval = 3;
      };
      input_number = {
        remote_current_light = {
          name = "Remote - Current light";
          initial = 0;
          min = 0;
          max = 2;
          step = 1;
        };
      };
    };
    extraComponents = [ "mqtt" "webostv" "sonos" "apple_tv" "homekit_controller" "thread" ];
  };
  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.unstable.zigbee2mqtt_2;
    settings = {
      permit_join = false;
      serial = {
        adapter = "deconz";
        port = "/dev/serial/by-id/usb-dresden_elektronik_ingenieurtechnik_GmbH_ConBee_II_DE2653212-if00";
      };
      availability = true;
      homeassistant = true;
      mqtt = {
        server = "mqtt://localhost";
        user = "zigbee2mqtt";
        password = "!/.secret/mosquittoZM.yaml password";
      };
      frontend.port = 8080;
      advanced = {
        homeassistant_legacy_entity_attributes = false;
        homeassistant_legacy_triggers = false;
        legacy_api = false;
        legacy_availability_payload = false;
      };
      device_options.legacy = false;
    };
  };
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          home-assistant = {
            passwordFile = "/.secret/mosquittoHA.pass";
            acl = [ "readwrite #" ];
          };
          zigbee2mqtt = {
            passwordFile = "/.secret/mosquittoZM.pass";
            acl = [ "readwrite #" ];
          };
        };
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [
    config.services.home-assistant.config.http.server_port
    config.services.home-assistant.config.homekit.port
    config.services.zigbee2mqtt.settings.frontend.port
    1400 # Sonos push updates
  ]
  ++ builtins.map (x: x.port) config.services.mosquitto.listeners;

}
