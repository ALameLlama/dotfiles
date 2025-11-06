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
      ../../home/profiles/full.nix
    ];

    home.packages = with pkgs; [
      # wtfutil
    ];
  };
}
