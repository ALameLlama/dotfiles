# Auto-discovery for dendritic modules
# Finds all home.nix and nixos.nix files in tree/modules/ and its subdirectories

{ lib }:
let
  treeDir = ./.;
  modulesDir = treeDir + "/modules";

  # Helper to join paths with proper slash using strings
  joinPath =
    a: b:
    let
      aStr = toString a;
      bStr = toString b;
    in
    /. + (aStr + "/" + bStr);

  # Recursively find all home.nix files (for home-manager modules)
  findHomeModules =
    dir:
    let
      entries = builtins.readDir dir;
      processEntry =
        name: type:
        if type == "directory" then
          let
            subdir = joinPath dir name;
            homeFile = joinPath subdir "home.nix";
            modFile = joinPath subdir "mod.nix";
            hasHome = builtins.pathExists homeFile;
            hasMod = builtins.pathExists modFile;
            submodules = findHomeModules subdir;
          in
          if hasHome then
            # This directory has a home.nix, use it
            [
              {
                name = name;
                path = homeFile;
              }
            ]
          else if hasMod then
            # No home.nix but has mod.nix, use mod.nix (legacy single-module format)
            [
              {
                name = name;
                path = modFile;
              }
            ]
          else
            # Neither found, recurse into subdirectories
            submodules
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processEntry entries);

  # Recursively find all nixos.nix files (for NixOS modules)
  findNixosModules =
    dir:
    let
      entries = builtins.readDir dir;
      processEntry =
        name: type:
        if type == "directory" then
          let
            subdir = joinPath dir name;
            nixosFile = joinPath subdir "nixos.nix";
            hasNixos = builtins.pathExists nixosFile;
            submodules = findNixosModules subdir;
          in
          if hasNixos then
            # This directory has a nixos.nix, it's a NixOS module
            [
              {
                name = name;
                path = nixosFile;
              }
            ]
          else
            # No nixos.nix, recurse into subdirectories
            submodules
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processEntry entries);

  # Get all discovered modules
  allHomeModules = findHomeModules modulesDir;
  allNixosModules = findNixosModules modulesDir;

  # Convert to attribute sets
  homeModulesAttr = lib.listToAttrs (
    map (m: {
      name = m.name;
      value = import m.path { inherit lib; };
    }) allHomeModules
  );

  nixosModulesAttr = lib.listToAttrs (
    map (m: {
      name = m.name;
      value = import m.path { inherit lib; };
    }) allNixosModules
  );
in
{
  homeModules = homeModulesAttr;
  nixosModules = nixosModulesAttr;
}
