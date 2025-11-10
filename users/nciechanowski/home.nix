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
      ../../home
      # ../../home/profiles/full.nix
    ];

    features = {
      programs = {
        neovim.enable = true;
        tmux.enable = true;
        shell.enable = true;
        cli-tooling.enable = true;
        wezterm.enable = true;
        git.enable = true;
      };

      languages = {
        php.enable = false;
        python.enable = false;
        javascript = {
          enable = true;
          fnm.enable = false;
        };
        rust.enable = true;
        lua.enable = true;
        go.enable = true;
        zig.enable = true;
      };

      tools = {
        nix-tools.enable = true;
        utilities.enable = true;
        fonts.enable = true;
      };
    };

    home.packages = with pkgs; [
      # wtfutil
    ];
  };
}
