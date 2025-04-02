{ config, pkgs, ... }:

let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "main";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
in {
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

    # (php.withExtensions ({ enabled, all, }: enabled ++ [ all.imagick ]))
    # php.packages.composer

    gh
  ];

  programs = {

    # Let Home Manager install and manage itself.
    home-manager = { enable = true; };
    git = {
      enable = true;
      userName = "Nicholas Ciechanowski";
      userEmail = "nicholasaciechanowski@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };
    gh = { enable = true; };
    # TODO:, look into manually stying this since I can't see selected input
    tmux = {
      enable = true;

      # Set your default shell and terminal
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";

      # Enable mouse and set escape time
      mouse = true;
      escapeTime = 1;

      # Set base index for windows and panes
      baseIndex = 1;

      # Set prefix to Ctrl-Space
      prefix = "C-Space";

      # Use vi-style keybindings
      keyMode = "vi";

      # Enable tmux plugins and install them automatically
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
        catppuccin
        resurrect
        continuum
      ];

      # Additional configuration for custom bindings and plugins
      extraConfig = ''
        # Enable clipboard and color overrides
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -s set-clipboard on

        # Use Alt-arrow keys to switch panes without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        run '~/.tmux/plugins/tpm/tpm'

        # Astronvim-style splits
        unbind '"'
        unbind '%'
        bind '\' split-window -v -c "#{pane_current_path}"
        bind '|' split-window -h -c "#{pane_current_path}"
      '';
    };
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
