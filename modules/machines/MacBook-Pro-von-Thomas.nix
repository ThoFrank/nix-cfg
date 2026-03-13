{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin;
in
{
  configurations.darwin.MacBook-Pro-von-Thomas.module = {
    imports = [
      # nixos.addUnstable
      # config.flake.modules.addUnstable
      # darwin.nix
      darwin.user
      inputs.determinate.darwinModules.default
      ../../includes/common
      ../../machines/Thomas-MacBook-Pro.nix
      inputs.home-manager.darwinModules.home-manager
      {determinateNix.enable = true;}
    ];
    nixpkgs.hostPlatform = "aarch64-darwin";
    meta = {
      homeDir = "/Users/thomas";
    };
  };
}
