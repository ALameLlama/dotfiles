{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.programs.cli-tooling.enable {
    home.packages = with pkgs; [
      bat
      entr
      eza
      fzf
      superfile # use mc if this doesn't work
      zoxide
      pay-respects
      jq
    ];

    programs = {
      zsh = {
        shellAliases = lib.mkAfter {
          ls = "eza --icons";
          ll = "eza -alh --icons";
          tree = "eza --tree --icons";

          cat = "bat";

          cd = "z";
          zz = "z -";

          fuck = "f";
        };

      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
