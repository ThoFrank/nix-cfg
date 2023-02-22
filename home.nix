{ config, pkgs, lib, ... }:

let machine = import ./machine.nix;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = machine.username;
  home.homeDirectory = machine.homedir;

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
    pkgs.libreoffice
    pkgs.just
    pkgs.btop
    pkgs.sqlitebrowser
  ]
  ++ lib.optionals (machine.operatingSystem != "Darwin")
    [
      # linux only
      pkgs.spotify
      pkgs.minecraft
    ]
  ++ lib.optionals (machine.operatingSystem == "Darwin") [
    # darwin only
    pkgs.mas
    pkgs.libiconv
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
      theme = "everforest_dark";
      editor = {
        true-color = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
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
      if pkgs.stdenv.isDarwin
      then
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
        ''
      else
        "";
  };
}
