# Git dendritic module
# Provides git and gh configuration for home-manager

{ lib }:
{
  config,
  lib,
  pkgs,
  ...
}:
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
      if echo "$branch" | grep -Eq '^(master|main|dev)$'; then
        continue
      fi

      if git branch --merged | grep -qE "^\s+$branch$"; then
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
  options.features.programs.git.enable = lib.mkEnableOption "Git configuration and scripts";

  config = lib.mkIf config.features.programs.git.enable {
    home.packages = with pkgs; [
      git
      gh
      gitPr
      gitC
      gitAttr
    ];

    programs = {
      git = {
        enable = true;
        settings.user = {
          name = "Nicholas Ciechanowski";
          email = "nicholas@ciech.anow.ski";
        };
      };
      gh = {
        enable = true;
      };
    };
  };
}
