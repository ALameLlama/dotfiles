# Shell NixOS module

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.shell = import ./nixos.nix { inherit lib; };
  users.defaultUserShell = pkgs.zsh;
}
