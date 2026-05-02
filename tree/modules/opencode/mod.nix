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
  options.features.programs.opencode.enable = lib.mkEnableOption "OpenCode";

  config = lib.mkIf config.features.programs.opencode.enable {
    home.packages = with pkgs; [
      opencode
    ];


    home.file = {
      ".config/opencode".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode";
    };
  };
}
