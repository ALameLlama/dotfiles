# Developer Profile
# Focused on core development tools with select languages
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
      php.enable = true;
      python.enable = true;
      javascript.enable = true;
      rust.enable = true;
      lua.enable = true;
      go.enable = false;
      zig.enable = false;
    };

    tools = {
      nix-tools.enable = true;
      utilities.enable = true;
      fonts.enable = true;
    };
  };
}
