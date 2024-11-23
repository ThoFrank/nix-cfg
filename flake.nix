{
  description = "My setup";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    
    psv-register-wa = {
      url = "github:PSV-Bogenschiessen/psv-register/VM-WA";
    };
    psv-register-feld = {
      url = "github:PSV-Bogenschiessen/psv-register/VM-Feld";
    };
    psv-register-indoor = {
      url = "github:PSV-Bogenschiessen/psv-register/Indoor";
    };
    psv-register-halle = {
      url = "github:PSV-Bogenschiessen/psv-register/VM-Halle";
    };
    psv-register-cup = {
      url = "github:PSV-Bogenschiessen/psv-register/PSV-Cup";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }: {
    overlays = {
      addUnstable = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; config.allowUnfree = true;};
        }
      );
    };
    nixosConfigurations."Nix-PC" = nixpkgs.lib.nixosSystem rec {
     system = "x86_64-linux";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/home/thomas";
        };
      };
      modules = [
        {
          disabledModules = [ "services/web-apps/mealie.nix" ];
          imports = [ "${inputs.unstable}/nixos/modules/services/web-apps/mealie.nix" ];
        }
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./includes/common
        ./machines/Nix-PC
        home-manager.nixosModules.home-manager
        inputs.psv-register-wa.nixosModules."${system}".psv-registration
        inputs.psv-register-feld.nixosModules."${system}".psv-registration
        inputs.psv-register-indoor.nixosModules."${system}".psv-registration
        inputs.psv-register-halle.nixosModules."${system}".psv-registration
        inputs.psv-register-cup.nixosModules."${system}".psv-registration
      ];
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
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./includes/common
        ./machines/beelink
        home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
      ];
    };
    nixosConfigurations."Nix-Pi" = nixpkgs.lib.nixosSystem {
     system = "aarch64-linux";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/home/thomas";
        };
      };
      modules = [
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.raspberry-pi-4
        nixos-hardware.nixosModules.common-pc-ssd
        ./includes/common
        ./machines/Nix-Pi/configuration.nix
        inputs.nixos-generators.nixosModules.all-formats
      ];
    };
    darwinConfigurations."Thomas-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/Users/thomas";
        };
      };
      modules = [
        ./includes/common
        ./machines/Thomas-MacBook-Pro.nix
        home-manager.darwinModules.home-manager
        {_module.args.var = {username = "thomas"; homedir = "/Users/thomas";};}
      ];
    };
  };
}
