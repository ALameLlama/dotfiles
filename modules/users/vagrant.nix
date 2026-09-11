{ inputs, ... }:
{
  flake.modules.homeManager.vagrant = {
    imports = with inputs.self.modules.homeManager; [
      cli-tools
      git
      jujutsu
      neovim
      opencode-omo
      shell
      tmux
      javascript-fnm
      go
      lua
      python
      fonts
      nix-tools
      utilities
      ./_vagrant.nix
    ];
  };
}
