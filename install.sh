#!/bin/sh
mkdir -p $HOME/.config/nixpkgs
ln -s $(pwd)/config.nix $HOME/.config/nixpkgs/config.nix
ln -s $(pwd)/home.nix $HOME/.config/nixpkgs/home.nix