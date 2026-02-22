# JavaScript/Node.js home module
# Provides JavaScript/Node.js development environment for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.languages.javascript = {
    enable = lib.mkEnableOption "JavaScript/Node.js development";
    fnm.enable = lib.mkEnableOption "Fast Node Manager (fnm)";
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.languages.javascript.enable {
      home.packages = with pkgs; [
        nodejs
      ];
    })

    (lib.mkIf config.features.languages.javascript.fnm.enable {
      home.packages = with pkgs; [
        fnm
      ];

      programs.zsh = lib.mkIf config.features.programs.shell.enable {
        initContent = lib.mkBefore ''
          eval "$(fnm env --use-on-cd --shell zsh)"
        '';
      };

      programs.bash = lib.mkIf config.programs.bash.enable {
        initExtra = ''
          eval "$(fnm env --use-on-cd --shell bash)"
        '';
      };
    })
  ];
}
