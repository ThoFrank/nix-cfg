{ config, pkgs, vars, ... }:

{
  nix = {
    # gc.automatic = true;
    settings.auto-optimise-store = !pkgs.stdenv.isDarwin;
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators
    '';
  };
  
  nixpkgs = {
    config.allowUnfree = true;
    config.hardware.enableRedistributableFirmware = true;
  };
}
