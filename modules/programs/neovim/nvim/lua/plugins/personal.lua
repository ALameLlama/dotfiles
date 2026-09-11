return {
	{
		"VidocqH/lsp-lens.nvim",
		cmd = {
			"LspLensOn",
			"LspLensOff",
			"LspLensToggle",
		},
		opts = {},
	},
	{
		"sphamba/smear-cursor.nvim",
		event = "User AstroFile",
		opts = {},
	},
	{
		"gregorias/coerce.nvim",
		event = "User AstroFile",
		opts = {},
	},
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10,
		opts = {
			enabled = true,
			overwrite = {
				yank = {
					enabled = true,
					default_animation = {
						name = "fade",
						settings = {
							from_color = "DiffChange",
							min_duration = 1000,
						},
					},
				},
				search = {
					enabled = true,
					default_animation = {
						name = "pulse",
						settings = {
							min_duration = 1000,
						},
					},
				},
				paste = {
					enabled = true,
					default_animation = {
						name = "reverse_fade",
						settings = {
							from_color = "DiffChange",
							min_duration = 1000,
						},
					},
				},
				undo = {
					enabled = true,
					default_animation = {
						name = "fade",
						settings = {
							from_color = "DiffAdd",
							min_duration = 1000,
						},
					},
				},
				redo = {
					enabled = true,
					default_animation = {
						name = "fade",
						settings = {
							from_color = "DiffDelete",
							min_duration = 1000,
						},
					},
				},
			},
		},
	},
}
