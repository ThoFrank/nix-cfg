# https://github.com/mightyiam/infra/blob/8597551a09b9e072e35a874afd040b3a91dac59a/modules/nixpkgs/instance.nix
{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
{
  options.nixpkgs = {
    config = {
      allowUnfreePredicate = lib.mkOption {
        type = lib.types.functionTo lib.types.bool;
        default = _: false;
      };
      allowUnfreePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [ ];
      };
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [ ];
    };
  };

  config = {
    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (config.nixpkgs) config overlays;
        };
      };

    flake.modules.nixos.nix = nixosArgs: {
      nixpkgs = {
        pkgs = withSystem nixosArgs.config.hardware.facter.report.system (psArgs: psArgs.pkgs);
        hostPlatform = nixosArgs.config.hardware.facter.report.system;
      };
    };
  };
}
