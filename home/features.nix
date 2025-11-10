{ lib, ... }:
{
  options.features = {
    programs = {
      neovim.enable = lib.mkEnableOption "Neovim configuration";
      tmux.enable = lib.mkEnableOption "Tmux configuration";
      shell.enable = lib.mkEnableOption "Shell (zsh) configuration";
      cli-tooling.enable = lib.mkEnableOption "CLI tools (bat, eza, fzf, etc.)";
      wezterm.enable = lib.mkEnableOption "WezTerm terminal configuration";
      git.enable = lib.mkEnableOption "Git configuration and scripts";
    };

    languages = {
      php.enable = lib.mkEnableOption "PHP development environment";
      python.enable = lib.mkEnableOption "Python development environment";
      javascript = {
        enable = lib.mkEnableOption "JavaScript/Node.js development environment";
        fnm.enable = lib.mkEnableOption "Fast Node Manager (fnm) with shell integration";
      };
      rust.enable = lib.mkEnableOption "Rust development environment";
      lua.enable = lib.mkEnableOption "Lua development environment";
      go.enable = lib.mkEnableOption "Go development environment";
      zig.enable = lib.mkEnableOption "Zig development environment";
    };

    tools = {
      nix-tools.enable = lib.mkEnableOption "Nix development tools (alejandra, nixd, etc.)";
      utilities.enable = lib.mkEnableOption "General utilities (dive, opencode, lsof)";
      fonts.enable = lib.mkEnableOption "Custom fonts";
    };
  };
}
