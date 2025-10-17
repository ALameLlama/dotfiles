{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.languages.rust.enable {
    home.packages = with pkgs; [
      rustup
    ];
  };
}
