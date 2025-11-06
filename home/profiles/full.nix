# Full Development Profile
# Enables all features and languages for a complete development environment
{
  features = {
    programs = {
      neovim.enable = true;
      tmux.enable = true;
      shell.enable = true;
      cli-tooling.enable = true;
      wezterm.enable = true;
      git.enable = true;
    };

    languages = {
      php.enable = false;
      python.enable = true;
      javascript.enable = true;
      rust.enable = true;
      lua.enable = true;
      go.enable = true;
      zig.enable = true;
    };

    tools = {
      nix-tools.enable = true;
      utilities.enable = true;
      fonts.enable = true;
    };
  };
}
