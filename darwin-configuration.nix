{ config, pkgs, ... }:
let
  user = "thomas";
in rec {
  imports = [
    <home-manager/nix-darwin>
    (import ./pam.nix)
  ];
  environment.systemPackages =
    [ 
      pkgs.vim
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.${user}.home = "/Users/${user}";

  home-manager.users.${user} = import ./home.nix;
  home-manager.useUserPackages = true;
  security.pam.enableSudoTouchIdAuth = true;
}
