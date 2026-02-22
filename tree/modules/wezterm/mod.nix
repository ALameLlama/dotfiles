# WezTerm dendritic module
# Provides WezTerm configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.wezterm.enable = lib.mkEnableOption "WezTerm terminal configuration";

  config = lib.mkIf config.features.programs.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file = {
      ".wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/programs/wezterm/wezterm.lua";
    };
  };
}
