{ config, pkgs, vars, ... }:
{
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.alacritty
    ];
  environment.shells = [ pkgs.zsh ];

  nix = {
    enable = true;
    linux-builder = {
      # enable = true;
      ephemeral = true;
      maxJobs = 4;
      config.virtualisation = {
        cores = 4;
        darwin-builder.memorySize = 8 * 1024;
      };
    };
    settings.trusted-users = [ vars.username ];
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.${vars.username} = {
    home = vars.homedir;
    shell = pkgs.zsh;
  };
  home-manager.users.${vars.username} = import ../home.nix vars;

  home-manager.useGlobalPkgs = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = ["/Applications"];
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
}
