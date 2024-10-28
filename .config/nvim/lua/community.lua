-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Bars and Lines
  { import = "astrocommunity.bars-and-lines.scope-nvim" }, -- Adds Tabs :tabnew,:tabnext and :tabprevious
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" }, -- Max characater limit
  { import = "astrocommunity.bars-and-lines.vim-illuminate" }, -- Highlight words under cursor, <a-n> <a-p> <a-i> to navigate

  -- Code Runners
  { import = "astrocommunity.code-runner.compiler-nvim" }, -- :Compiler* commands

  -- Comments
  { import = "astrocommunity.comment.ts-comments-nvim" }, -- Better commenting out code

  -- Completion
  { import = "astrocommunity.completion.magazine-nvim" },
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-emoji" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  -- Debugging
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },

  -- Diagnostics
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- Editing Support
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  -- { import = "astrocommunity.editing-support.bigfile-nvim" }, -- Need to see if this is better then astrocore large_buf
  { import = "astrocommunity.editing-support.copilotchat-nvim" }, -- Copilot chat,
  { import = "astrocommunity.editing-support.hypersonic-nvim" }, -- :Hypersonic for regex explainer
  { import = "astrocommunity.editing-support.mini-splitjoin" }, -- Split/Join params with gS
  { import = "astrocommunity.editing-support.neogen" }, -- Annotation generator
  { import = "astrocommunity.editing-support.nvim-context-vt" }, -- Virtual Text for end statements
  { import = "astrocommunity.editing-support.nvim-origami" }, -- Code Folding
  { import = "astrocommunity.editing-support.nvim-treesitter-context" }, -- Sticy scroll
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" }, -- Rainbow brackets
  { import = "astrocommunity.editing-support.refactoring-nvim" }, -- Refactoring keygroup
  { import = "astrocommunity.editing-support.suda-vim" }, -- Sudo write
  { import = "astrocommunity.editing-support.telescope-undo-nvim" }, -- <Leader>fu
  { import = "astrocommunity.editing-support.text-case-nvim" }, -- :TextCaseOpenTelescope
  { import = "astrocommunity.editing-support.vim-visual-multi" }, -- More info https://github.com/mg979/vim-visual-multi

  -- Git
  { import = "astrocommunity.git.blame-nvim" }, -- <Leader>gB
  { import = "astrocommunity.git.diffview-nvim" }, -- <Leader>gd
  { import = "astrocommunity.git.gitgraph-nvim" }, -- <Leader>g|
  { import = "astrocommunity.git.gitlinker-nvim" }, -- <Leader>gy

  -- LSP
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" }, -- :IncRename
  { import = "astrocommunity.lsp.lsp-signature-nvim" },

  -- Markdown
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },

  -- Motion
  { import = "astrocommunity.motion.harpoon" },

  -- Search
  { import = "astrocommunity.search.grug-far-nvim" },

  -- Neo Dev
  { import = "astrocommunity.neovim-lua-development.helpview-nvim" },

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

  -- Test
  { import = "astrocommunity.test.vim-test" },
}
