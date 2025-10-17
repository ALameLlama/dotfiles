{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.zig.enable {
    home.packages = with pkgs; [
      zig_0_15
    ];
  };
}
