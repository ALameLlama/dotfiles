return {
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.blade" },
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
	{
		"windwp/nvim-ts-autotag",
		enabled = false,
	},
}
