{ config, pkgs, vars, ... }:
{
  environment.systemPackages =
    [
      pkgs.vim
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.${vars.username}.home = vars.homedir;
  home-manager.users.${vars.username} = import ./home.nix vars;

  home-manager.useGlobalPkgs = true;
  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      trusted-users = @wheel
    '';
      # builders = ssh://nix-pc x86_64-linux ; ssh://nix-pc aarch64-linux
   };
}
