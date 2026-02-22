# WezTerm
# Provides WezTerm configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.wezterm.enable = lib.mkEnableOption "WezTerm terminal";

  config = lib.mkIf config.features.programs.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file = {
      ".wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/wezterm/wezterm.lua";
    };
  };
}
