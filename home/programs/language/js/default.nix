{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Base JavaScript configuration
    (lib.mkIf config.features.languages.javascript.enable {
      home.packages = with pkgs; [
        nodejs
      ];
    })

    # fnm (Fast Node Manager) configuration
    (lib.mkIf config.features.languages.javascript.fnm.enable {
      home.packages = with pkgs; [
        fnm
      ];

      programs.zsh = lib.mkIf config.features.programs.shell.enable {
        initContent = lib.mkBefore ''
          # Fast Node Manager (fnm) initialization
          eval "$(fnm env --use-on-cd --shell zsh)"
        '';
      };

      programs.bash = lib.mkIf config.programs.bash.enable {
        initExtra = ''
          # Fast Node Manager (fnm) initialization
          eval "$(fnm env --use-on-cd --shell bash)"
        '';
      };
    })
  ];
}
