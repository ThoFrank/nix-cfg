# Uses the option in `./nixos.nix` to declare a NixOS configuration.
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.P14s.module = {
    imports = [
      nixos.user
      nixos.desktop
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.home-manager.nixosModules.home-manager
      ../../includes/common
      ../../machines/P14s/configuration.nix
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}

