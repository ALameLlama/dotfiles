# Nix Tools dendritic module
# Provides Nix development tools for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.tools.nix-tools.enable =
    lib.mkEnableOption "Nix development tools (alejandra, nixd, etc.)";

  config = lib.mkIf config.features.tools.nix-tools.enable {
    home.packages = with pkgs; [
      alejandra
      deadnix
      nixd
      statix
      nixfmt
      nixpkgs-review
    ];
  };
}
