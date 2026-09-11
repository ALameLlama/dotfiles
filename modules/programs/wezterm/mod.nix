{ lib, ... }:
{
  flake.modules.homeManager.wezterm = {
  config,
  lib,
  pkgs,
  ...
}:
{

  
    home.packages = with pkgs; [ wezterm ];

    home.file = {
      ".wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/wezterm/wezterm.lua";
    };
  
}
;
}
