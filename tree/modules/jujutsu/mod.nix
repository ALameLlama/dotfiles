# Jujutsu
# Provides jujutsu for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.features.programs.jujutsu.enable = lib.mkEnableOption "Jujutsu";

  config = lib.mkIf config.features.programs.jujutsu.enable {
    home.packages = with pkgs; [
      jujutsu
      delta
    ];

    programs = {
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Nicholas Ciechanowski";
            email = "nicholas@ciech.anow.ski";
          };
          ui = {
            default-command = "log";
          };
        };
      };
    };
  };
}
