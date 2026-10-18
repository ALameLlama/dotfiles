{ lib, ... }:
{
  options.dotfiles.updates = lib.mkOption {
    default = { };
    description = "Commands that program modules add to dfu.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether dfu runs this update.";
          };
          command = lib.mkOption {
            type = lib.types.lines;
            description = "The shell commands for this update.";
          };
        };
      }
    );
  };
}
