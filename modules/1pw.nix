# Default shell for the user across NixOS and Android
{ config, lib, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.desktop = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password-gui"
      "1password"
    ];
    # Alternatively, you could also just allow all unfree packages
    # nixpkgs.config.allowUnfree = true;

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ config.meta.username ];
    };
  };
}
