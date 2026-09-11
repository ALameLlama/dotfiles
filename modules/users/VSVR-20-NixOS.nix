{ inputs, ... }:
{
  flake.modules.homeManager."VSVR-20-NixOS" = {
    imports = with inputs.self.modules.homeManager; [
      cli-tools
      git
      jujutsu
      opencode-omo
      tmux
      go
      lua
      python
      rust
      zig
      php-debug
      nix-tools
      utilities
      ./_VSVR-20-NixOS.nix
    ];
  };
}
