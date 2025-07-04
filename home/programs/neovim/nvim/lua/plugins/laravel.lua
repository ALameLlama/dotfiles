return {
	{ import = "astrocommunity.pack.php" },
	{ import = "astrocommunity.pack.html-css" },
	{ import = "astrocommunity.pack.blade" },
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
						default = { "laravel", "lsp", "path", "snippets", "buffer" },
						providers = {
							laravel = {
								name = "laravel",
								module = "laravel.blink_source",
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
