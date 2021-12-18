{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

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
    pkgs.spotify
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
    ];
    userSettings = {
      "security.workspace.trust.enabled" = false;
    };
  };
}
