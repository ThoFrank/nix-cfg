{ config, pkgs, vars, ... }:

{
  imports =
    [
      ./configuration.nix
      ./hardware-configuration.nix
    ];
}