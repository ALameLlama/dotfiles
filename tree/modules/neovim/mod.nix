# Neovim
# Provides Neovim configuration

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.neovim = import ./nixos.nix { inherit lib; };
  flake.homeModules.neovim = import ./home.nix { inherit lib; };
}
