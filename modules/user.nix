{ config, ... }:
{
  flake.modules = {
    nixos.user = {pkgs, ...}: {
      users.users."${config.username}" = {
        isNormalUser = true;
        description = config.gitUserName;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$d5MspDwW25ZV9kZk7PkOt/$qY9FWeapItAEzLrdbMmPR3PG/Do9vUMXWopf9MHPm61";
      };

      home-manager.users.${config.username} = import ../home.nix config;
    };

    darwin.user = {pkgs, ...}: {
      system.primaryUser = config.username;
      users.users.${config.username} = {
        home = config.homeDir;
        shell = pkgs.zsh;
      };
      home-manager.users.${config.username} = import ../home.nix config;
    };
  };
}
