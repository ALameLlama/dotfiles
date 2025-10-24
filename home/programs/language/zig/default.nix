{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.languages.zig.enable {
    home.packages = with pkgs; [
      zig_0_15
    ];
  };
}
