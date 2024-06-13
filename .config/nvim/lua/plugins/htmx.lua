---@type LazySpec
return {
  {
    "ThePrimeagen/htmx-lsp",
    ft = { "h mx" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "htmx" },
    },
  },
}
