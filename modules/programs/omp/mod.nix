{ inputs, ... }:
{
  flake.modules.homeManager.omp =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config.home.packages = [ pkgs.omp ];

      config.home.activation.seedOmpMarketplaces = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        if [ ! -e "$HOME/.omp/marketplaces.json" ]; then
          run ${pkgs.coreutils}/bin/install -Dm600 ${./marketplaces.json} "$HOME/.omp/marketplaces.json"
        fi
      '';

      config.home.file = {
        ".omp/agent/skills/simple-english".source = "${inputs.simple-english}/skills/simple-english";
        ".omp/agent/skills/caveman".source = "${inputs.caveman}/skills/caveman";
        ".omp/agent/RULES.md".text = ''
          # Output style routing

          Apply these rules in the main session and every subagent.
          Read skill://caveman once before writing chat, progress updates, delegation briefs, or subagent reports.
          Use Caveman only for that communication: answer first, omit filler and routine tool narration, and keep reports concise.
          Preserve requirements, acceptance criteria, evidence, errors, negations, numbers, paths, and safety warnings.

          Read skill://simple-english once before writing or editing prose that will enter the repository.
          Use SimpleEnglish for comments, docstrings, documentation, README files, changelogs, and other committed prose.
          Follow existing repository formatting and use full, clear sentences for that prose, not Caveman shorthand.
          Do not simplify code, commands, identifiers, exact errors, or required literals; change them only as the task requires.

          Choose the style per output surface, including within mixed responses.
          This routing overrides either skill's global reply-style and persistence rules; do not activate either style globally.
          Quoted repository prose in chat keeps its SimpleEnglish wording.
        '';
        ".omp/config.yml".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/config.yml";
        ".omp/agent/config.yml".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/programs/omp/config.yml";
      };
    };
}
