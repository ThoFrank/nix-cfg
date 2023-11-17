vars: { config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = vars.username;
  home.homeDirectory = vars.homedir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.rustup
    pkgs.tmux
    pkgs.thefuck
    pkgs.htop
    pkgs.nixpkgs-review
    pkgs.python3
    pkgs.fd
    pkgs.ripgrep
    pkgs.just
    pkgs.btop
    pkgs.sqlitebrowser
  ]
  ++ lib.optionals (pkgs.stdenv.isLinux)
    [
      # linux only
      pkgs.spotify
      pkgs.minecraft
      pkgs.libreoffice
    ]
  ++ lib.optionals (pkgs.stdenv.isDarwin) [
    # darwin only
    pkgs.mas
    pkgs.libiconv
    pkgs.nixos-shell
    pkgs.iterm2
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
      };
      "freenas" = {
        hostname = "frankcloud.firewall-gateway.com";
        user = "root";
        port = 5522;
        identityFile = "~/.ssh/id_rsa_NAS";
      };
      "fewo" = {
        hostname = "krimmlmonster.selfhost.eu";
        user = "pi";
        identityFile = "~/.ssh/nexus_id_rsa";
        port = 4445;
      };
      "backuppi" = {
        hostname = "10.0.0.137";
        user = "ubuntu";
        identityFile = "~/.ssh/id_rsa_backup_pi";
      };
      "nixpi" = {
        hostname = "192.168.1.118";
        user = "pi";
        identityFile = "~/.ssh/id_pi";
        port = 22;
      };
      "nix-pc" = {
        hostname = "cloud.franks-im-web.de";
        user = "thomas";
        identityFile = "~/.ssh/nix-pc";
      };
      "code.tvl.fyi" = {
        hostname = "code.tvl.fyi";
        user = "thofrank";
        port = 29418;
        identityFile = "~/.ssh/tvl_gerrit";
      };
    };
  };
  programs.git = {
    enable = true;
    userName = "Thomas Frank";
    userEmail = "thomas@franks-im-web.de";
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      justusadam.language-haskell
      matklad.rust-analyzer
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
    ];
    userSettings = {
      "security.workspace.trust.enabled" = false;
      "update.mode" = "none";
      "terminal.integrated.persistentSessionReviveProcess" = "never";
    };
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "rust"
        "man"
        "thefuck"
        "fd"
        "ripgrep"
      ];
      theme = "robbyrussell";
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "one_dark";
    };
  };


  home.activation = {
    copyApplications =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      pkgs.lib.mkIf pkgs.stdenv.isDarwin
       ( lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -d "$baseDir" ]; then
            rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '');
  };
}
