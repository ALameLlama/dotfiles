{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.features.programs.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file = {
      ".wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/programs/wezterm/wezterm.lua";
    };
  };
}
