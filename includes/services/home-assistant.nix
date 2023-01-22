{ config, pkgs, ... }:
let 
tradfriId = "dbc59b818db34ac47dbed7f59dc9a6de";
klotzId = "ee235610828d45e10750d7fb8749ee98";
buildKlotzAutomation = {alias, triggerSubType, actionType}: {
  inherit alias;
  trigger = {
    platform = "device";
    type = "remote_button_short_press";
    subtype = triggerSubType;
    domain = "zha";
    device_id = tradfriId;
  };
  action = {
    domain = "light";
    device_id = klotzId;
    type = actionType;
    entity_id = "light.klotz";
  };
  mode = "single";
};
in {
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
      homekit = {};
      "automation ui" = "!include automations.yaml";
      "automation manual" = [
        (buildKlotzAutomation {alias = "tradfri - dim down"; triggerSubType = "dim_down"; actionType = "brightness_decrease";})
        (buildKlotzAutomation {alias = "tradfri - dim up"; triggerSubType = "dim_up"; actionType = "brightness_increase";})
        (buildKlotzAutomation {alias = "tradfri - toggle"; triggerSubType = "turn_on"; actionType = "toggle";})
      ];
      switch = {
        platform = "flux";
        name = "Tageszeit Temperatur";
        lights = ["light.klotz" "light.pilz" "light.deckenlampe"];
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
  };
}
