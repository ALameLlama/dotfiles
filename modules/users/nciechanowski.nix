{ inputs, ... }:
{
  flake.modules.homeManager.nciechanowski = {
    imports = with inputs.self.modules.homeManager; [
      cli-tools git jujutsu opencode-omo tmux wezterm go lua python rust zig php-debug fonts nix-tools utilities
      ./_nciechanowski.nix
    ];
  };
}
