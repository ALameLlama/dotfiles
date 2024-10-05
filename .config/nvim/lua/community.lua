-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Bars and Lines
  { import = "astrocommunity.bars-and-lines.scope-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },

  -- Code Runners
  { import = "astrocommunity.code-runner.compiler-nvim" },

  -- Comments
  { import = "astrocommunity.comment.ts-comments-nvim" },

  -- Completion
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-emoji" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  -- Debugging
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },

  -- Diagnostics
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- Editing Support
  -- { import = "astrocommunity.editing-support.auto-save-nvim" }, -- I need to fix the debounce setting otherwise trying to use undo is unusable
  -- { import = "astrocommunity.editing-support.bigfile-nvim" }, -- Need to see if this is better then astrocore large_buf
  { import = "astrocommunity.editing-support.copilotchat-nvim" }, -- Copilot chat,
  { import = "astrocommunity.editing-support.cutlass-nvim" }, -- Cutlass overrides the delete operations to actually just delete and not affect the current yank.
  { import = "astrocommunity.editing-support.mini-splitjoin" }, -- Split/Join params with gS
  { import = "astrocommunity.editing-support.multiple-cursors-nvim" }, -- Multi cursor
  { import = "astrocommunity.editing-support.nvim-treesitter-context" }, -- Sticy scroll
  { import = "astrocommunity.editing-support.suda-vim" }, -- Sudo write

  -- Packs
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.blade" },
  { import = "astrocommunity.pack.gleam" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.laravel" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.yaml" },

  -- Markdown
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },

  -- Other
  { import = "astrocommunity.neovim-lua-development.helpview-nvim" },
  { import = "astrocommunity.test.vim-test" },
}
