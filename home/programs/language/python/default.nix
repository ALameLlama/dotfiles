{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.python.enable {
    home.packages = [
      (pkgs.python313.withPackages (
        p: with p; [
          playwright
          pip
          uv
        ]
      ))
    ];
  };
}
