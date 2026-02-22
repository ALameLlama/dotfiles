# Shell NixOS module
# Sets the default shell to zsh for all users when any user has shell enabled

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Check if any user has shell enabled
  anyUserHasShell = lib.any (userConfig: userConfig.features.programs.shell.enable or false) (
    lib.attrValues config.home-manager.users
  );
in
{
  config = lib.mkIf anyUserHasShell {
    # Enable zsh system-wide (required for proper PATH setup)
    programs.zsh.enable = true;

    # Set zsh as the default shell for all users
    users.defaultUserShell = pkgs.zsh;

    # Ensure zsh is available system-wide
    environment.shells = [ pkgs.zsh ];

    # Enable zsh completions for system packages
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
