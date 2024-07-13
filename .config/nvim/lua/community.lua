-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- { import = "astrocommunity.colorscheme.catppuccin" },

  -- AI
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.chatgpt-nvim" },

  -- Packs
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.gleam" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.yaml" },

  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.blade" },

  -- Cmps
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-emoji" },

  -- Other
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.suda-vim" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
}
