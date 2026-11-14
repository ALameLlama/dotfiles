{ ... }:
{
  flake.modules.homeManager.magpie =
    { config, lib, pkgs, ... }:
    let
      magpie = pkgs.callPackage ./_package.nix { };
    in
    {
      imports = [ ../shell/_updates.nix ];

      dotfiles.updates.magpie.command = ''
        ${pkgs.python3}/bin/python3 ${./_update.py} \
          "$HOME/.dotfiles/modules/programs/magpie/_sources.json" || return 1
      '';

      home.packages = [ magpie ];

      systemd.user.services.magpie = {
        Unit.Description = "Magpie local model gateway";
        Service = {
          Type = "simple";
          ExecStart = "${magpie}/bin/magpie serve";
          Environment = [
            "MAGPIE_ADDR=127.0.0.1:3425"
            "PATH=${lib.makeBinPath [ pkgs.omp pkgs.coreutils ]}:${config.home.homeDirectory}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin"
          ];
          Restart = "on-failure";
          RestartSec = 5;
          UMask = "0077";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
