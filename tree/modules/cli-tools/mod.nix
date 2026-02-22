# CLI Tools dendritic module
# Provides CLI tooling configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.features.programs.cli-tools.enable = lib.mkEnableOption "CLI tools (bat, eza, fzf, etc.)";

  config = lib.mkIf config.features.programs.cli-tools.enable {
    home.packages = with pkgs; [
      bat
      entr
      eza
      fzf
      superfile
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
