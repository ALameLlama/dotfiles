# Dotfiles

NixOS and Home Manager configuration that uses flake-parts and the dendritic pattern.

## Install

```sh
bash <(curl -s https://raw.githubusercontent.com/ALameLlama/dotfiles/master/scripts/installer.sh)
```

## Daily commands

| Command | Action |
| --- | --- |
| `dfn` | Open `~/.dotfiles` in Neovim. |
| `dfg` | Open `~/.dotfiles` in Lazygit. |
| `dfcd` | Change to `~/.dotfiles`. |
| `dfs [host] [args]` | Apply the NixOS or Home Manager configuration. |
| `dfu` | Update flake inputs and Neovim plugins. |
| `dfc` | Optimize the Nix store and remove old generations. |

Examples:

```sh
dfs
dfs razorback
dfs razorback --show-trace
```

On NixOS, `dfs` uses `nixos-rebuild switch`. On other systems, it uses the matching `vagrant-<system>` Home Manager configuration.

## Make a change

1. Run `dfn` to open the repository.
2. Edit an aspect under `modules/`.
3. If you changed `modules/flake.nix`, run `nix run .#write-flake`.
4. Run `dfs` to apply the configuration.
5. Run `dfg` to review and commit the change.

Do not edit `flake.nix`. The `write-flake` package generates it from `modules/flake.nix`.

## Layout

```text
modules/
  programs/       Program aspects
  languages/      Language toolchains
  tools/          General tools and fonts
  hosts/          NixOS host aspects
  users/          Home Manager user aspects
  configurations.nix
  flake.nix       Flake inputs and flake-file configuration
```

`import-tree` loads each Nix module under `modules/`. Files with an underscore prefix are private payload modules and are not loaded automatically.

To add a feature, create its module under the applicable category. Then import its aspect from a host or user module.

## Validation

```sh
nix flake check
nix build --no-link .#checks.x86_64-linux.check-flake-file
```
