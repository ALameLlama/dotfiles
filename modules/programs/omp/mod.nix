{ inputs, ... }:
{
  flake.modules.homeManager.omp =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.omp.homeManagerModules.default
      ];

      programs.omp = {
        enable = true;
      };

      home.file = {
        ".omp/marketplaces.json".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/marketplaces.json";
        ".omp/config.yml".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/config.yml";
        ".omp/agent/config.yml".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/config.yml";
        ".omp/agent/plugins".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/plugins";
      };
    };
}
