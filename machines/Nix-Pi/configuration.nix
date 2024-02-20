{pkgs, vars, ...}:
{
  networking.hostName = "Nix-Pi"; # Define your hostname.
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
  };

  environment.systemPackages = with pkgs; [
    helix
    tmux
    wget
  ];


  services.openssh.enable = true;
  
  services.octoprint = {
    enable = true;
    openFirewall = true;
  };
}
