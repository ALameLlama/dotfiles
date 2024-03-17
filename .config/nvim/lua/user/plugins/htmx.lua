local utils = require("astronvim.utils")
return {
	{
		"ThePrimeagen/htmx-lsp",
		version = "^0.1",
		ft = { "htmx" },
		init = function()
			astronvim.lsp.setup = utils.list_insert_unique(astronvim.lsp.setup, "htmx")
		end,
	},
}
