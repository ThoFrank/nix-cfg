{ config, pkgs, vars, ... }:

{
  nix = {
    gc.automatic = true;
    settings.auto-optimise-store = !pkgs.stdenv.isDarwin;
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  nixpkgs = {
    config.allowUnfree = true;
  };
}
