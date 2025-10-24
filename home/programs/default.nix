{ config, pkgs, ... }:
{
  imports = [
    ./cli-tooling
    ./git
    ./language
    ./neovim
    ./shell
    ./tmux
    ./wezterm
  ];
}
