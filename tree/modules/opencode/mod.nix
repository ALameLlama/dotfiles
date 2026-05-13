# OpenCode
# Provides OpenCode configuration

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.opencode = {
    enable = lib.mkEnableOption "OpenCode";
    config = {
      super = lib.mkEnableOption "OpenCode Super Config";
      omo = lib.mkEnableOption "OpenCode OMO Config";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.programs.opencode.enable {
      home.packages = with pkgs; [
        opencode
      ];
    })

    (lib.mkIf config.features.programs.opencode.config.super {
      home.file = {
        ".config/opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode-super";
      };
    })

    (lib.mkIf config.features.programs.opencode.config.omo {
      home.file = {
        ".config/opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode-omo";
      };
    })
  ];
}
