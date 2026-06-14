# Uses the option in `./nixos.nix` to declare a NixOS configuration.
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.beelink.module = {
    disabledModules = [
      "services/web-apps/mealie.nix"
      "services/home-automation/home-assistant.nix"
      "services/home-automation/zigbee2mqtt.nix"
    ];
    imports = [
      nixos.user
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      ../../includes/common
      ../../machines/beelink
      "${inputs.unstable}/nixos/modules/services/web-apps/mealie.nix"
      "${inputs.unstable}/nixos/modules/services/home-automation/home-assistant.nix"
      "${inputs.unstable}/nixos/modules/services/home-automation/zigbee2mqtt.nix"
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
    nixpkgs.overlays = [
      (prev: final: {
        unstable = import inputs.unstable { inherit (final) system config;};
      })
    ];
  };
}
