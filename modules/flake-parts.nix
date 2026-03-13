# https://github.com/mightyiam/dendritic/blob/master/example/modules/flake-parts.nix
{ inputs, ... }:
{
  imports = [
    # https://flake.parts/options/flake-parts-modules.html
    inputs.flake-parts.flakeModules.modules
  ];
}
