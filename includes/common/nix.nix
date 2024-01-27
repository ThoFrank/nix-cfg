{ config, pkgs, vars, ... }:

{
  nix = {
    gc.automatic = true;
    settings.auto-optimise-store = true;
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  nixpkgs = {
    config.allowUnfree = true;
  };
}