return {}

-- local utils = require "astronvim.utils"
-- return {
--   { import = "astrocommunity.pack.toml" },
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       if opts.ensure_installed ~= "all" then
--         opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "rust")
--       end
--     end,
--   },
--   {
--     "mrcjkb/rustaceanvim",
--     ft = { "rust" },
--     init = function()
--       astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "rust_analyzer")
--       local cfg = require "rustaceanvim.config"
--       local success, package = pcall(function() return require("mason-registry").get_package "codelldb" end)
--       if success then
--         local package_path = package:get_install_path()
--         local codelldb_path = package_path .. "/codelldb"
--         local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"
--         local this_os = vim.loop.os_uname().sysname
--
--         -- The path in windows is different
--         if this_os:find "Windows" then
--           codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
--           liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
--         else
--           -- The liblldb extension is .so for linux and .dylib for macOS
--           liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
--         end
--         return {
--           dap = {
--             adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
--           },
--         }
--       else
--         return {
--           dap = {
--             adapter = cfg.get_codelldb_adapter(),
--           },
--         }
--       end
--     end,
--     dependencies = {
--       {
--         "jay-babu/mason-nvim-dap.nvim",
--         opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "codelldb") end,
--       },
--     },
--   },
--   -- {
--   --   "mrcjkb/rustaceanvim",
--   --   version = "^3",
--   --   ft = { "rust" },
--   --   init = function() astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "rust_analyzer") end,
--   -- },
--   {
--     "williamboman/mason-lspconfig.nvim",
--     opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "rust_analyzer") end,
--   },
--   {
--     "Saecki/crates.nvim",
--     event = { "BufRead Cargo.toml" },
--     init = function()
--       vim.api.nvim_create_autocmd("BufRead", {
--         group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
--         pattern = "Cargo.toml",
--         callback = function()
--           require("cmp").setup.buffer { sources = { { name = "crates" } } }
--           require "crates"
--         end,
--       })
--     end,
--     opts = {
--       null_ls = {
--         enabled = true,
--         name = "crates.nvim",
--       },
--     },
--   },
-- }
