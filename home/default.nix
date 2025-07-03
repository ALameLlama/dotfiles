{ config, pkgs, ... }:

{
  nix = {
    # package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    python3
    python312Packages.pip
    pipx
    poetry

    lua51Packages.lua
    lua51Packages.luarocks
    # luajit

    nodejs # see if this is needed or if this causes conflicts with fnm
    fnm

    rustup # this will install cargo and rustc without conflicting
    # rustc
    # cargo
    go
    zig

    # nix packages
    alejandra
    deadnix
    nixd
    statix
    nixfmt

    nerd-fonts.fira-code

    git
    gh
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager = { enable = true; };
    git = {
      enable = true;
      userName = "Nicholas Ciechanowski";
      userEmail = "nicholasaciechanowski@gmail.com";
      # extraConfig.init.defaultBranch = "main";
    };
    gh = { enable = true; };
  };
}
