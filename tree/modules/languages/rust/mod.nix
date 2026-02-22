# Rust dendritic module
# Provides Rust development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.rust.enable = lib.mkEnableOption "Rust development environment";

  config = lib.mkIf config.features.languages.rust.enable {
    home.packages = with pkgs; [
      rustup
    ];
  };
}
