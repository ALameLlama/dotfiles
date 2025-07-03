{ pkgs, ... }:
let username = "nciechanowski";
in {
  programs.zsh.enable = true;
  users.users.${username} = { shell = pkgs.zsh; };

  home-manager.users.${username} = {
    imports = [
      ../../home
      ../../home/programs/shell
      ../../home/programs/tmux
      ../../home/programs/cli-tooling
      ../../home/programs/neovim
      ../../home/programs/wezterm
    ];
  };
}
