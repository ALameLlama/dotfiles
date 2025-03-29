{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      # AstroNvim packages
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
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # TODO: move this to relative path
    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.dotfiles/.config/nvim";
    };
  };
}

