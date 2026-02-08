{
  config,
  lib,
  pkgs,
  ...
}:
{
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
