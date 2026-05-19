# OpenCode
# Provides OpenCode configuration

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.opencode = {
    enable = lib.mkEnableOption "OpenCode";
    config = {
      super = lib.mkEnableOption "OpenCode Super Config";
      omo = lib.mkEnableOption "OpenCode OMO Config";
      izaro = lib.mkEnableOption "OpenCode izaro Config";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.programs.opencode.enable {
      home.packages = with pkgs; [
        opencode
      ];

      programs.zsh = lib.mkIf config.features.programs.shell.enable {
        initContent = lib.mkAfter ''
          export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=1
        '';
      };

      programs.bash = lib.mkIf config.programs.bash.enable {
        initExtra = lib.mkAfter ''
          export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=1
        '';
      };
    })

    (lib.mkIf config.features.programs.opencode.config.super {
      home.file = {
        ".config/opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode-super";
      };
    })

    (lib.mkIf config.features.programs.opencode.config.omo {
      home.file = {
        ".config/opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode-omo";
      };
    })

    (lib.mkIf config.features.programs.opencode.config.izaro {
      home.file = {
        ".config/opencode".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/tree/modules/opencode/opencode-izaro";
      };
    })
  ];
}
