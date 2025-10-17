{ pkgs, ... }:
let
  username = "nciechanowski";
in
{
  programs.zsh.enable = true;
  users.users.${username} = {
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = {
    imports = [
      ../../home/features.nix
      ../../home/core.nix
      ../../home/programs/shell
      ../../home/programs/tmux
      ../../home/programs/cli-tooling
      ../../home/programs/neovim
      ../../home/programs/wezterm
      ../../home/programs/git
      ../../home/programs/language
      ../../home/nix-tools.nix
      ../../home/fonts.nix
      ../../home/utilities.nix
      ../../home/profiles/full.nix
    ];
  };
}
