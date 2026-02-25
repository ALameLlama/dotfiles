return {
	{ import = "astrocommunity.pack.html-css" },
	-- { import = "astrocommunity.pack.blade" },
	-- Blade
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = { filetypes = { pattern = { [".*%.blade%.php"] = "blade" } } },
	},
	{
		"AstroNvim/astrolsp",
		optional = true,
		---@param opts AstroLSPOpts
		opts = function(_, opts)
			opts.config.blade = {
				cmd = { "laravel-dev-generators", "lsp" },
				filetypes = { "blade" },
				root_dir = function(fname)
					return require("lspconfig").util.find_git_ancestor(fname)
				end,
			}

			if vim.fn.executable("laravel-dev-generators") == 1 then
				opts.servers = require("astrocore").list_insert_unique(opts.servers, { "blade" })
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = function(_, opts)
			require("nvim-treesitter.parsers").blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			if opts.ensure_installed ~= "all" then
				opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "blade" })
			end
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed =
				require("astrocore").list_insert_unique(opts.ensure_installed, { "blade_formatter" })
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed =
				require("astrocore").list_insert_unique(opts.ensure_installed, { "blade-formatter" })
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				blade = { "blade-formatter" },
			},
		},
	},
	-- PHP
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = function(_, opts)
			if opts.ensure_installed ~= "all" then
				opts.ensure_installed =
					require("astrocore").list_insert_unique(opts.ensure_installed, { "php", "phpdoc" })
			end
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "phpactor" })
			-- opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "intelephense" })
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "php" })
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		optional = true,
		opts = function(_, opts)
			-- opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "php-cs-fixer" })
			opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "pint" })
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").list_insert_unique(
				opts.ensure_installed,
				{ "phpactor", "php-debug-adapter", "pint" }
				-- { "intelephense", "php-debug-adapter", "php-cs-fixer" }
			)
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				-- php = { "php_cs_fixer" },
				php = { "pint" },
			},
		},
	},
	{
		"adibhanna/laravel.nvim",
		event = { "VeryLazy" },
		cmd = {
			"Artisan",
			"Composer",
			"Sail",
			"LaravelMake",
			"LaravelRoutes",
			"LaravelGoto",
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			{
				"AstroNvim/astrocore",
				---@param opts AstroCoreOpts
				opts = function(_, opts)
					local maps = assert(opts.mappings)
					local prefix = "<Leader>L"
					maps.n[prefix] = { desc = require("astroui").get_icon("Laravel", 1, true) .. "Laravel" }
					maps.n[prefix .. "D"] = { desc = require("astroui").get_icon("Dump", 1, true) .. "Dump Menu" }
				end,
			},
			{ "AstroNvim/astroui", opts = { icons = { Laravel = "󰫐", Dump = "" } } },
		},
		specs = {
			{
				"Saghen/blink.cmp",
				optional = true,
				opts = {
					sources = {
						default = { "laravel" },
						providers = {
							laravel = {
								name = "laravel",
								module = "laravel.blink_source",
								-- https://github.com/Saghen/blink.cmp/issues/1098
								-- There currently really isn't a way to do what I want, I want this to exist after the lsp
								score_offset = -4000,
								transform_items = function(ctx, items)
									for _, item in ipairs(items) do
										item.kind_icon = "󰫐"
										item.kind_name = "Laravel"
									end
									return items
								end,
							},
						},
					},
				},
				dependencies = {
					{
						-- We disable autotag closing in php files since it breaks blink.cmp
						---@see https://github.com/saghen/blink.cmp/issues/2234#issuecomment-3461410965
						"windwp/nvim-ts-autotag",
						optional = true,
						opts = {
							per_filetype = {
								["php"] = { enable_close = false },
							},
						},
					},
				},
			},
			{
				"hrsh7th/nvim-cmp",
				optional = true,
				opts = {
					sources = { { name = "laravel", priority = 750 } },
				},
			},
		},
		opts = {
			notifications = false,
		},
	},
}
