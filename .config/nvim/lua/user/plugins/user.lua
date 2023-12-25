return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "User AstroFile",
    cmd = { "TodoQuickFix" },
    keys = {
      { "<leader>T", "<cmd>TodoTelescope<cr>", desc = "Open TODOs in Telescope" },
    },
  },
  -- TODO: NVIM 0.10, This is native, we can remove this.
  {
    "ojroques/nvim-osc52",
  },
  -- TODO: Look into this plugin.
  -- {
  --   "jpmcb/nvim-llama",
  --   config = function()
  --     require("nvim-llama").setup {
  --       model = "codellama",
  --     }
  --   end,
  -- },
  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = {
      -- -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      -- {
      --   "<leader>Oo",
      --   ":<c-u>lua require('ollama').prompt()<cr>",
      --   desc = "ollama prompt",
      --   mode = { "n", "v" },
      -- },
      --
      -- -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      -- {
      --   "<leader>OG",
      --   ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      --   desc = "ollama Generate Code",
      --   mode = { "n", "v" },
      -- },
    },
    opts = {
      model = "codellama:13b",
      url = os.getenv "LLAMA_URL",
      -- View the actual default prompts in ./lua/ollama/prompts.lua
      prompts = {
        -- Sample_Prompt = {
        --   prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
        --   input_label = "> ",
        --   model = "codellama:13b",
        --   action = "display",
        -- },
      },
    },
  },
}
