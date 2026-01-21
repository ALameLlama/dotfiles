return {
	-- Syntax + filetype support
	{
		"amber-lang/amber-vim",
		ft = { "amber" },
	},

	{
		"AstroNvim/astrolsp",
		---@param opts AstroLSPOpts
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			table.insert(opts.servers, "amber_lsp")

			opts.config = require("astrocore").extend_tbl(opts.config or {}, {
				amber_lsp = {
					cmd = { "/home/nciechanowski/Projects/amber-lsp/target/release/amber-lsp" },
					filetypes = { "amber" },
				},
			})
		end,
	},
}
