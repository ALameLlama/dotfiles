# Neovim NixOS module
# Provides nix-ld when Neovim is enabled (needed for marksman to work with generic Linux node binaries)

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Check if any user has neovim enabled
  anyUserHasNeovim = lib.any (userConfig: userConfig.features.programs.neovim.enable or false) (
    lib.attrValues config.home-manager.users
  );
in
{
  config = lib.mkIf anyUserHasNeovim {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        icu
      ];
    };
  };
}
