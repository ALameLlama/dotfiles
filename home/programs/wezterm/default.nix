{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ wezterm ];

  home.file = {
    ".config/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/programs/wezterm/wezterm.lua";
  };
}

