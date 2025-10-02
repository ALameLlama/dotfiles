{ config, pkgs, ... }:

let
  gitPr = pkgs.writeShellScriptBin "git-pr" ''
    title="$(git rev-parse --abbrev-ref HEAD)"
    cmd=(gh pr create --title "$title" --draft)

    if [ -f ".github/pull_request_template.md" ]; then
      cmd+=(--body-file .github/pull_request_template.md)
    fi

    "''${cmd[@]}"
  '';
  gitC = pkgs.writeShellScriptBin "git-c" ''
    git fetch --prune

    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
      # Skip main branches
      if echo "$branch" | grep -Eq '^(master|main|dev)$'; then
        continue
      fi

      # Check if branch is fully merged into HEAD
      if git branch --merged | grep -qE "^\s+$branch$"; then
        # Check if upstream is gone
        upstream=$(git for-each-ref --format='%(upstream:short)' "refs/heads/$branch")
        if [ -n "$upstream" ] && ! git show-ref --verify --quiet "refs/remotes/$upstream"; then
          echo "Deleting local branch '$branch' (upstream gone)"
          git branch -d "$branch"
        fi
      fi
    done

    git fsck
    git gc
    git prune
    git fsck
  '';
  gitAttr = pkgs.writeShellScriptBin "git-attr" ''
    git archive --format=tar HEAD > latest.tar 
    tar -tvf latest.tar
    rm -rf latest.tar
  '';
in
{
  nix = {
    # package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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

    (python313.withPackages (
      p: with p; [
        playwright
        pip
        uv
      ]
    ))

    # (luajit.withPackages (p: with p; [ luarocks ]))
    (lua5_1.withPackages (p: with p; [ luarocks ]))

    nodejs # see if this is needed or if this causes conflicts with fnm
    fnm

    rustup # this will install cargo and rustc without conflicting
    # rustc
    # cargo

    # zig
    zig_0_15
    go

    # nix packages
    alejandra
    deadnix
    nixd
    statix
    nixfmt

    # nerd-fonts.fira-code
    maple-mono.NF

    git
    gh
    gitPr
    gitC
    gitAttr

    dive
    # posting

    opencode
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Nicholas Ciechanowski";
      userEmail = "nicholas@ciech.anow.ski";
      # extraConfig.init.defaultBranch = "main";
    };
    gh = {
      enable = true;
    };
  };
}
