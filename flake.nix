{
  description = "My setup";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }: {
    overlays = {
      addUnstable = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; config.allowUnfree = true;};
        }
      );
    };
    nixosConfigurations."Nix-PC" = nixpkgs.lib.nixosSystem ( {
     system = "x86_64-linux";
      specialArgs = {
        var = {
          username = "thomas";
          homedir = "/home/thomas";
        };
      };
      modules = [
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./configuration.nix
        home-manager.nixosModules.home-manager
        inputs.psv-register-wa.nixosModules."${self.system}".psv-registration
        inputs.psv-register-feld.nixosModules."${self.system}".psv-registration
        inputs.psv-register-indoor.nixosModules."${self.system}".psv-registration
        inputs.psv-register-halle.nixosModules."${self.system}".psv-registration
      ];
    });
    darwinConfigurations."Thomas-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = {
        vars = {
          username = "thomas";
          homedir = "/Users/thomas";
        };
      };
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {_module.args.var = {username = "thomas"; homedir = "/Users/thomas";};}
      ];
    };
  };
}
