# Uses the option in `./nixos.nix` to declare a NixOS configuration.
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.beelink.module = {
    imports = [
      nixos.user
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      ../../includes/common
      ../../machines/beelink
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
