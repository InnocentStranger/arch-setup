return {
	-- for making vim.ui.select/vim.ui.input to be like telescope ui
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	config = function()
		require("dressing").setup({
			select = {
				backend = { "telescope", "builtin" },
			},
		})
	end,
}
