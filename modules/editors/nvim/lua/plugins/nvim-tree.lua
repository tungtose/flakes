return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "tt", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
	},
	config = function()
		vim.keymap.set("n", "<leader>n", ":NvimTreeForcus<CR>")
		vim.keymap.set("n", "<C-n>", ":NvimTreeOpen<CR>")
		vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>")
		vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")

		require("nvim-tree").setup({ -- BEGIN_DEFAULT_OPTS
			sort_by = "case_sensitive",
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
			view = {
				adaptive_size = true,
				mappings = {
					list = {
						{ key = "u", action = "dir_up" },
						{ key = "s", action = "" },
						{ key = "o", action = "system_open" },
					},
				},
				side = "left",
			},
		})
	end,
}
