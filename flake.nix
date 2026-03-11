{
  description = "My setup";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }: {
    overlays = {
      addUnstable = (
        final: prev: {
          unstable = import inputs.unstable { system = final.stdenv.hostPlatform.system; config.allowUnfree = true;};
        }
      );
    };
    nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/home/thomas";
        };
      };
      modules = [
        {
          disabledModules = [
            "services/web-apps/mealie.nix"
            "services/home-automation/home-assistant.nix"
            "services/home-automation/zigbee2mqtt.nix"
          ];
          imports = [
            "${inputs.unstable}/nixos/modules/services/web-apps/mealie.nix"
            "${inputs.unstable}/nixos/modules/services/home-automation/home-assistant.nix"
            "${inputs.unstable}/nixos/modules/services/home-automation/zigbee2mqtt.nix"
          ];
        }
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./includes/common
        ./machines/beelink
        home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
      ];
    };
    darwinConfigurations."MacBook-Pro-von-Thomas" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/Users/thomas";
        };
      };
      modules = [
        inputs.determinate.darwinModules.default
        ./includes/common
        ./machines/Thomas-MacBook-Pro.nix
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        home-manager.darwinModules.home-manager
        {_module.args.var = {username = "thomas"; homedir = "/Users/thomas";};}
      ];
    };
  };
}
