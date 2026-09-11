{ inputs, ... }:
{
  flake.modules.homeManager.opencode =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        opencode
        openspec
      ];
      programs.zsh = lib.mkIf config.programs.zsh.enable {
        initContent = lib.mkAfter "export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=1";
      };
      programs.bash = lib.mkIf config.programs.bash.enable {
        initExtra = lib.mkAfter "export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=1";
      };
    };
  flake.modules.homeManager.opencode-nilla = { config, ... }: {
    imports = with inputs.self.modules.homeManager; [ opencode ];
    home.file.".config/opencode".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/opencode/opencode-nilla";
  };
  flake.modules.homeManager.opencode-omo = { config, ... }: {
    imports = with inputs.self.modules.homeManager; [ opencode ];
    home.file.".config/opencode".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/opencode/opencode-omo";
  };
  flake.modules.homeManager.opencode-super = { config, ... }: {
    imports = with inputs.self.modules.homeManager; [ opencode ];
    home.file.".config/opencode".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/opencode/opencode-super";
  };
}
