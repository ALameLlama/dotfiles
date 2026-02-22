# Neovim
# Provides Neovim configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.neovim.enable = lib.mkEnableOption "Neovim editor";

  config = lib.mkIf config.features.programs.neovim.enable {
    home.packages = with pkgs; [
      git
      gcc
      gnumake
      unzip
      tree-sitter
      bottom
      gdu
      fd
      ripgrep
      lazygit
      neovim
    ];

    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.file = {
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/neovim/nvim";
    };
  };
}
