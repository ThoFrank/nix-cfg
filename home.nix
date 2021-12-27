{ config, pkgs, lib, ... }:

let machine = import ./machine.nix;
in {
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
    pkgs.rustc
    pkgs.cargo
    pkgs.clang
    pkgs.tmux
    pkgs.thefuck
    pkgs.htop
  ]
  ++ lib.optionals (machine.operatingSystem != "Darwin")
  [
    # linux only
    pkgs.spotify
  ]
  ++ lib.optionals (machine.operatingSystem == "Darwin") [
    # darwin only
    pkgs.mas
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile  = "~/.ssh/github";
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
      ms-ceintl.vscode-language-pack-de
    ];
    userSettings = {
      "security.workspace.trust.enabled" = false;
    };
  };
}
