-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- AI
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.copilotchat-nvim" },

  -- Packs
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.gleam" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.yaml" },

  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.blade" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.laravel" },

  -- Cmps
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-emoji" },

  -- Markdown
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  -- Git
  { import = "astrocommunity.git.gitgraph-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },

  -- Other
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.suda-vim" },
  { import = "astrocommunity.test.vim-test" },
  { import = "astrocommunity.neovim-lua-development.helpview-nvim" },
}
