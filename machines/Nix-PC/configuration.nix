# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, vars, ... }:

{
  imports =
    [
      # ./monitoring
      ../../includes/zfs.nix
      ../../includes/services/nginx.nix
      ../../includes/services/letsencrypt.nix
      ../../includes/services/nextcloud.nix
      ../../includes/services/mariadb.nix
      ../../includes/services/home-assistant.nix
      ../../includes/services/samba.nix
      ../../includes/services/plex.nix
      ../../includes/services/minidlna.nix
      ../../includes/services/psv-register.nix
      ../../includes/services/homepage-dashboard.nix
      ../../includes/services/mealie.nix
      ../../includes/services/ddclient.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 20;
      systemd-boot.memtest86.enable = true;
    };    
    kernelModules = ["sg"];
  };
  

  networking.hostName = "Nix-PC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  # networking.useNetworkd = true;
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # container NAT
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp2s0";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = true;
  # networking.interfaces.enp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.wm.preferences]
    button-layout='close,minimize,maximize:'
    [org.gnome.settings-daemon.plugins.power]
    sleep-inactive-ac-timeout='nothing'
  '';


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    thomas = {
      isNormalUser = true;
      extraGroups = [ "wheel" "bilder" "cdrom" "docker" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
    root = {
      hashedPassword = "!";
      #home.packages = [ pkgs.atool pkgs.httpie ];
    };
    nextcloud = {
      extraGroups = [ "bilder" ];
    };
    tobias = {
      isNormalUser = true;
      createHome = false;
      home = "/var/psv-register";
    };
  };
  
  users.groups = {
    bilder = {}; # Access to /tank/Bilder
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    gnomeExtensions.dash-to-dock
    gparted
    nixpkgs-fmt
    docker-compose
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PasswordAuthentication = false;

  # services.httpd.enable = true;
  # services.httpd.adminAddr = "thomas@franks-im-web.de";
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80
    443
    21063 # homebridge
    25565 # minecraft
    config.services.home-assistant.config.http.server_port
  ] ++ config.services.openssh.ports;
  networking.firewall.allowedUDPPorts = [ 
    25565 # minecraft
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?


  ### ADDED BY ME
  home-manager.users.${vars.username} = import ../../home.nix vars;
  home-manager.useGlobalPkgs = true;
  programs.zsh.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  users.extraGroups.vboxusers.members = [ "thomas" ];
  users.extraGroups.docker.members = [ "thomas" ];
  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;


  # nginx reverse proxy
  # services.nginx.virtualHosts.${config.services.grafana.domain} = {
  # locations."/" = {
  # proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
  # proxyWebsockets = true;
  # };
  # };
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {

      "cloud.franks-im-web.de" = {
        ## Force HTTP redirect to HTTPS
        forceSSL = true;
        ## LetsEncrypt
        enableACME = true;
        serverAliases = ["frankcloud.firewall-gateway.com"];
      };
    };
  };

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = true;
  systemd.watchdog.rebootTime = "20m";
  system.autoUpgrade.flake = "${config.users.users.thomas.home}/src/nix-stuff";
  system.autoUpgrade.flags = ["--update-input" "nixpkgs" "--update-input" "unstable" "--commit-lock-file"];
  system.autoUpgrade.rebootWindow.lower = "01:00";
  system.autoUpgrade.rebootWindow.upper = "05:00";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  
  services.fwupd.enable = true;
  services.flatpak.enable = true;
}

