{
  description = "My setup";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, ... }: {
    overlays = {
      addUnstable = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; config.allowUnfree = true;};
        }
      );
    };
    nixosConfigurations."Nix-PC" = nixpkgs.lib.nixosSystem (rec {
       system = "x86_64-linux";
      modules = [
        {nixpkgs.overlays = [self.overlays.addUnstable];}
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./configuration.nix
        home-manager.nixosModules.home-manager
        inputs.psv-register-wa.nixosModules."${system}".psv-registration
        inputs.psv-register-feld.nixosModules."${system}".psv-registration
        inputs.psv-register-indoor.nixosModules."${system}".psv-registration
      ];
    });
  };
}
