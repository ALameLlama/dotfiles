---@type LazySpec
return {
  {
    "ThePrimeagen/htmx-lsp",
    ft = { "htmx" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "htmx" },
    },
  },
}
