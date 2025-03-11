# https://nixpk.gs/pr-tracker.html
# https://search.nixos.org/packages
{ pkgs, ... }:
with pkgs; [
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

  # prompt
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship
  carapace

  # AstroNvim packages
  neovim
  git
  gcc
  gnumake
  unzip
  tree-sitter
  bottom
  gdu
  fd

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
  ripgrep

  go
  lazygit

  # nix packages
  alejandra
  deadnix
  nixd
  statix
  nixfmt

  # extra packages
  bat
  entr
  eza
  fzf
  superfile # use mc if this doesn't work
  tmux
  zoxide
  pay-respects

  nerd-fonts.fira-code

  (php.withExtensions ({ enabled, all, }: enabled ++ [ all.imagick ]))
  php.packages.composer

  gh
]
