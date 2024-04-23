---@type LazySpec
return {
  {
    "ThePrimeagen/htmx-lsp",
    version = "^0.1",
    ft = { "htmx" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "htmx" },
    },
  },
}
