# JavaScript/Node.js NixOS module
# Provides nix-ld when fnm is enabled (needed for FNM to work with generic Linux node binaries)

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Check if any user has fnm enabled
  anyUserHasFnm = lib.any (userConfig: userConfig.features.languages.javascript.fnm.enable or false) (
    lib.attrValues config.home-manager.users
  );
in
{
  # No options needed - we read from home-manager config

  config = lib.mkIf anyUserHasFnm {
    programs.nix-ld = {
      enable = true;
      # libraries = with pkgs; [
      #   stdenv.cc.cc
      #   zlib
      #   glib
      #   libgcc
      # ];
    };
  };
}
