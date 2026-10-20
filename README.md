# Dotfiles

NixOS and Home Manager configuration that uses flake-parts and the dendritic pattern.

## Install

On standalone installs, the script deletes `~/.config/home-manager` and `~/.zshrc`. Back up both paths before running it.

```sh
bash <(curl -s https://raw.githubusercontent.com/ALameLlama/dotfiles/master/scripts/installer.sh)
```

The installer uses `nixos-rebuild` on NixOS and Home Manager otherwise.
Pass a configuration name to select a device explicitly:

```sh
bash <(curl -s https://raw.githubusercontent.com/ALameLlama/dotfiles/master/scripts/installer.sh) razorback
bash <(curl -s https://raw.githubusercontent.com/ALameLlama/dotfiles/master/scripts/installer.sh) vagrant
```

Without a name, NixOS uses the current hostname. Home Manager uses the current username.
Each device needs an exported configuration for its platform and user. The `vagrant` target only supports the ARM64 Linux VM.

## Daily commands

| Command | Action |
| --- | --- |
| `dfn` | Open `~/.dotfiles` in Neovim. |
| `dfg` | Open `~/.dotfiles` in Lazygit. |
| `dfcd` | Change to `~/.dotfiles`. |
| `dfs [host] [args]` | Apply the NixOS or Home Manager configuration. |
| `dfu` | Update flake inputs and run enabled updates from program modules. |
| `dfc` | Optimize the Nix store and remove old generations. |

Examples:

```sh
dfs
dfs razorback
dfs razorback --show-trace
```

On NixOS, `dfs` uses `nixos-rebuild switch`. Otherwise, it selects the named Home Manager configuration and defaults to `vagrant`.

The `vagrant` configuration targets the ARM64 Linux VM, not the Mac host. Apply it with `dfs vagrant` or:

```sh
home-manager switch --flake ~/.dotfiles#vagrant
```

`dfu` updates flake inputs, then runs enabled entries in `dotfiles.updates` in alphabetical order. Each program module adds its own entry. OMP adds an entry only when `programs.omp.usePrebuilt` is enabled.

The OMP updater reads the latest stable release from GitHub and updates its version and SHA-256 hashes for all four prebuilt targets. Missing or invalid release hashes leave the OMP pins unchanged. A failed flake update or OMP update stops `dfu`. Run `dfs` to install the updated release.

Program modules import the shared options and register their update commands in their Home Manager module. For example:

```nix
imports = [ ../shell/_updates.nix ];

dotfiles.updates.opencode.command = ''
  opencode plugin update
  opencode models --refresh
'';
```

To skip a program's update without removing the program, set its entry to `enable = false` in your Home Manager configuration:

```nix
dotfiles.updates.neovim.enable = false;
```

## Make a change

1. Run `dfn` to open the repository.
2. Edit an aspect under `modules/`.
3. Run `dfs` to regenerate `flake.nix` and apply the configuration.
4. Run `dfg` to review and commit the change.

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
