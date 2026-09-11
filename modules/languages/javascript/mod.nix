{ inputs, ... }:
{
  flake.modules.homeManager.javascript = { pkgs, ... }: {
    home.packages = with pkgs; [
      nodejs
      bun
    ];
  };

  flake.modules.homeManager.javascript-fnm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [ javascript ];
      home.packages = [ pkgs.fnm ];

      programs.zsh = lib.mkIf config.programs.zsh.enable {
        initContent = lib.mkBefore ''eval "$(fnm env --use-on-cd --shell zsh)"'';
      };
      programs.bash = lib.mkIf config.programs.bash.enable {
        initExtra = lib.mkBefore ''eval "$(fnm env --use-on-cd --shell bash)"'';
      };
    };

  flake.modules.nixos.javascript-fnm = { pkgs, ... }: {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glib
        libgcc
      ];
    };
    home-manager.sharedModules = [ inputs.self.modules.homeManager.javascript-fnm ];
  };
}
