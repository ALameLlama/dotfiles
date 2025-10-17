{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.tools.nix-tools.enable {
    home.packages = with pkgs; [
      alejandra
      deadnix
      nixd
      statix
      nixfmt
    ];
  };
}
