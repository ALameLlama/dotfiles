{ inputs, ... }:
{
  flake.modules.homeManager.neovim =
    # Neovim
    # Provides Neovim configuration for home

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/neovim/nvim";
      };
    };

  flake.modules.nixos.neovim =
    # Neovim NixOS module
    # Provides nix-ld when Neovim is enabled (needed for marksman to work with generic Linux node binaries)

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          icu
        ];
      };
      home-manager.sharedModules = [ inputs.self.modules.homeManager.neovim ];
    };
}
