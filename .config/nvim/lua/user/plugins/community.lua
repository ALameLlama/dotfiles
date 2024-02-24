return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- Theme
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- AI
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  { import = "astrocommunity.editing-support.chatgpt-nvim" },

  -- Packs
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.yaml" },

  -- Other
  { import = "astrocommunity.editing-support.suda-vim" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },

  -- Replaced with our own one
  -- TODO: Swap over with NVIM 0.10,
  { import = "astrocommunity.pack.rust" },
}
