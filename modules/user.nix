{
  flake.modules = {
    nixos.user = {pkgs, config, ...}: {
      users.users."${config.meta.username}" = {
        isNormalUser = true;
        description = config.meta.gitUserName;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$d5MspDwW25ZV9kZk7PkOt/$qY9FWeapItAEzLrdbMmPR3PG/Do9vUMXWopf9MHPm61";
      };

      home-manager.users.${config.meta.username} = import ../home.nix config.meta;
    };

    darwin.user = {pkgs, config, ...}: {
      system.primaryUser = config.meta.username;
      users.users.${config.meta.username} = {
        home = config.meta.homeDir;
        shell = pkgs.zsh;
      };
      home-manager.users.${config.meta.username} = import ../home.nix config.meta;
    };
  };
}
