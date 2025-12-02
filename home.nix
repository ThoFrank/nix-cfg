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
    pkgs.htop
    pkgs.nixpkgs-review
    pkgs.python3
    pkgs.fd
    pkgs.ripgrep
    pkgs.just
    pkgs.btop
    pkgs.sqlitebrowser
    pkgs.gh
    pkgs.nil
    pkgs.devenv

    pkgs.nerd-fonts.comic-shanns-mono
  ]
  ++ lib.optionals (pkgs.stdenv.isLinux)
    [
      # linux only
      pkgs.spotify
      # pkgs.minecraft
      pkgs.libreoffice
    ]
  ++ lib.optionals (pkgs.stdenv.isDarwin) [
    # darwin only
    pkgs.mas
    pkgs.libiconv
    pkgs.nixos-shell
    pkgs.iterm2
    pkgs.texliveFull
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
    settings = {
      user = {
        name = "Thomas Frank";
        email = "thomas@franks-im-web.de";
      };
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      catppuccin
    ];
    extraConfig = ''
      set -sg escape-time 0
      set -g mouse on
      
      set -g default-terminal "''${TERM}"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm' # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m' # underscore colours - needs tmux-3.0

      # fix darwin shell
      # https://github.com/nix-community/home-manager/issues/5952#issuecomment-2409056750
      set -gu default-command
      set -g default-shell "$SHELL"
    '';
      # set -g mouse-select-pane on
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        justusadam.language-haskell
        rust-lang.rust-analyzer
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ];
      userSettings = {
        "security.workspace.trust.enabled" = false;
        "update.mode" = "none";
        "terminal.integrated.persistentSessionReviveProcess" = "never";
      };
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
      ];
      theme = "robbyrussell";
    };
    initContent = ''
      if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
        tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
      fi
    '';
  };
  programs.carapace.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "onedark";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal = {family = "ComicShannsMono Nerd Font"; style = "Regular";};
      font.size = 14;
    };
  };
  fonts.fontconfig.enable = true;
}
