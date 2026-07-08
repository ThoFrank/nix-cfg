# Default shell for the user across NixOS and Android
{ config, lib, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.desktop = {
    services.tailscale.enable = true;
  };
}

