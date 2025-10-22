{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.python.enable {
    home.packages = with pkgs; [
      (python313.withPackages (
        p: with p; [
          playwright
          pip
          uv
        ]
      ))
    ];
  };
}
