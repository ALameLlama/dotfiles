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
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  { import = "astrocommunity.editing-support.mini-splitjoin" }, -- Split/Join params with gS
  { import = "astrocommunity.editing-support.neogen" }, -- Annotation generator
  { import = "astrocommunity.editing-support.nvim-context-vt" }, -- Virtual Text for end statements
  { import = "astrocommunity.editing-support.nvim-origami" }, -- Code Folding
  { import = "astrocommunity.editing-support.nvim-treesitter-context" }, -- Sticy scroll
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" }, -- Rainbow brackets
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.suda-vim" }, -- Sudo write
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.text-case-nvim" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },

  -- Git
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },
  { import = "astrocommunity.git.gitlinker-nvim" },

  -- LSP
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },

  -- Markdown
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },

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

  -- Other
  { import = "astrocommunity.neovim-lua-development.helpview-nvim" },
  { import = "astrocommunity.test.vim-test" },
}
