{pkgs, vars, ...}:
{
  networking.hostName = "Nix-Pi";
  system.stateVersion = "23.11";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  users.users."${vars.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnYDy3H18dSPWQxDcJLqT/H3zlQITaNSChuQayEs8Xj thomas@Nix-PC"
    ];
  };

  environment.systemPackages = with pkgs; [
    helix
    tmux
    wget
    git
    (callPackage ../../programs/camera-streamer {stdenv = clangStdenv;})
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  
  nixpkgs.overlays = [(import ../../overlays/octoprint_plugins.nix)];
  services.octoprint = {
    enable = true;
    openFirewall = true;
    plugins = p: [p.octoprint-M73ETAOverride];
  };

  services.mjpg-streamer.enable = true;
}
