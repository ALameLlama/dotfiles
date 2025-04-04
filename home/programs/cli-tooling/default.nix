{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    entr
    eza
    fzf
    superfile # use mc if this doesn't work
    zoxide
    pay-respects
  ];

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
