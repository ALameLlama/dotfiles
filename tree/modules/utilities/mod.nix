# Utilities dendritic module
# Provides general utilities for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  nixpkgs-update = pkgs.writeShellScriptBin "nixpkgs-update" ''
    if [ -z "''${GITHUB_TOKEN-}" ]; then
      echo "Error: GITHUB_TOKEN is not set. Please set it to a valid GitHub token." >&2
      exit 1
    fi
    exec nix run \
      --option extra-substituters https://nix-community.cachix.org \
      --option extra-trusted-public-keys nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= \ 
      github:nix-community/nixpkgs-update -- "$@"
  '';
in
{
  options.features.tools.utilities.enable =
    lib.mkEnableOption "General utilities (dive, opencode, lsof)";

  config = lib.mkIf config.features.tools.utilities.enable {
    home.packages = with pkgs; [
      dive
      opencode
      lsof
      nixpkgs-update
    ];
  };
}
