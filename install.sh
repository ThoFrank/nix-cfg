#!/bin/sh
mkdir -p $HOME/.config/nixpkgs
rm $HOME/.config/nixpkgs/config.nix
ln -s $(pwd)/config.nix $HOME/.config/nixpkgs/config.nix
rm $HOME/.config/nixpkgs/home.nix
ln -s $(pwd)/home.nix $HOME/.config/nixpkgs/home.nix

echo "{ hostname = \"$(hostname)\"; username = \"$(whoami)\"; homedir = \"$HOME\"; operatingSystem = \"$(uname -v | awk '{ print $1 }' | sed 's/#.*-//')\"; }" > machine.nix