{ lib, ... }:
{
  flake.modules.homeManager.jujutsu =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {

      home.packages = with pkgs; [
        jujutsu
        delta
      ];

      programs = {
        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "Nicholas Ciechanowski";
              email = "nicholas@ciech.anow.ski";
            };
            ui = {
              default-command = "log";
            };
          };
        };
      };

    };
}
