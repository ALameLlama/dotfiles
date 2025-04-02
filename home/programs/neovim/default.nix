{ config, pkgs, ... }:

{
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

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/programs/neovim/nvim";
    # mkOutOfStoreSymlink dpes not work with relative paths :(
    # ".config/nvim".source =
    #   config.lib.file.mkOutOfStoreSymlink "${toString ./nvim}";
  };
}

