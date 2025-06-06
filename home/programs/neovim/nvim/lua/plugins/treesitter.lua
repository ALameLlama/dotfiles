-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"lua",
			"vim",
			"yaml",
			"json",
			"nix",
			"diff",
			-- add more arguments for adding more treesitter parsers
		},
	},
}
