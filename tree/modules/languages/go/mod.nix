# Go
# Provides Go development environment

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.go.enable = lib.mkEnableOption "Go development";

  config = lib.mkIf config.features.languages.go.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
