{ lib, ... }:
{
  options.features = with lib; {
    programs = {
      neovim.enable = mkEnableOption "Neovim configuration";
      tmux.enable = mkEnableOption "Tmux configuration";
      shell.enable = mkEnableOption "Shell (zsh) configuration";
      cli-tooling.enable = mkEnableOption "CLI tools (bat, eza, fzf, etc.)";
      wezterm.enable = mkEnableOption "WezTerm terminal configuration";
      git.enable = mkEnableOption "Git configuration and scripts";
    };

    languages = {
      php.enable = mkEnableOption "PHP development environment";
      python.enable = mkEnableOption "Python development environment";
      javascript.enable = mkEnableOption "JavaScript/Node.js development environment";
      rust.enable = mkEnableOption "Rust development environment";
      lua.enable = mkEnableOption "Lua development environment";
      go.enable = mkEnableOption "Go development environment";
      zig.enable = mkEnableOption "Zig development environment";
    };

    tools = {
      nix-tools.enable = mkEnableOption "Nix development tools (alejandra, nixd, etc.)";
      utilities.enable = mkEnableOption "General utilities (dive, opencode, lsof)";
      fonts.enable = mkEnableOption "Custom fonts";
    };
  };
}
