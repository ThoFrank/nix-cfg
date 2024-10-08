{ config, pkgs, vars, ... }:
{
  environment.systemPackages =
    [
      pkgs.vim
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.${vars.username}.home = vars.homedir;
  home-manager.users.${vars.username} = import ../home.nix vars;

  home-manager.useGlobalPkgs = true;
  security.pam.enableSudoTouchIdAuth = true;

}
