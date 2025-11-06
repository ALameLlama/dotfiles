{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.languages.rust.enable {
    home.packages = with pkgs; [
      rustup
    ];
  };
}
