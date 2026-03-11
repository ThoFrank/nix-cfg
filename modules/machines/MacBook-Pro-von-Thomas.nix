{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin nixos;
in
{
  homeDir = "/Users/thomas";
  configurations.darwin.MacBook-Pro-von-Thomas.module = {
    imports = [
      # nixos.addUnstable
      # config.flake.modules.addUnstable
      darwin.user
      inputs.determinate.darwinModules.default
      ../../includes/common
      ../../machines/Thomas-MacBook-Pro.nix
      inputs.home-manager.darwinModules.home-manager
      {determinateNix.enable = true;}
    ];
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
