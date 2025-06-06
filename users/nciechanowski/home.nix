{ pkgs, ... }: {
  imports = [
    ../../home
    ../../home/programs/shell
    ../../home/programs/tmux
    ../../home/programs/cli-tooling
    ../../home/programs/neovim
  ];
}
