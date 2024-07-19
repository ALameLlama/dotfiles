---@type LazySpec
return {
  {
    "ThePrimeagen/htmx-lsp",
    ft = { "htmx" },
    specs = {
      "williamboman/mason-lspconfig.nvim",
      optional = true,
      opts = function(_, opts)
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "htmx" })
      end,
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      opts.config = require("astrocore").extend_tbl(opts.config or {}, {
        htmx = {
          filetypes = { "blade", "html" },
        },
      })
    end,
  },
}
