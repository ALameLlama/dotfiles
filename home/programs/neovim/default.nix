{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.programs.neovim.enable {
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
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/programs/neovim/nvim";
      # mkOutOfStoreSymlink dpes not work with relative paths :(
      # ".config/nvim".source =
      #   config.lib.file.mkOutOfStoreSymlink "${toString ./nvim}";
    };
  };
}
