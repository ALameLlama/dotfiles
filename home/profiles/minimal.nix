# Minimal Profile
# Basic essential tools only
{
  features = {
    programs = {
      neovim.enable = true;
      tmux.enable = false;
      shell.enable = true;
      cli-tooling.enable = true;
      wezterm.enable = false;
      git.enable = true;
    };

    languages = {
      php.enable = false;
      python.enable = false;
      javascript.enable = false;
      rust.enable = false;
      lua.enable = false;
      go.enable = false;
      zig.enable = false;
    };

    tools = {
      nix-tools.enable = true;
      utilities.enable = false;
      fonts.enable = true;
    };
  };
}
