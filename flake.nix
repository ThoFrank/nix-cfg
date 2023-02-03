{
  description = "My setup";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    overlays = {
      addUnstable = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; config.allowUnfree = true;};
        }
      );
    };
    nixosConfigurations."Nix-PC" = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
      modules = [
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
