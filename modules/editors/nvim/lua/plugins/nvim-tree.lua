vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")
	vim.keymap.set("n", "<C-n>", ":NvimTreeOpen<CR>")
	vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>")
	vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")
end

return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup({
			on_attach = on_attach,
			sort_by = "case_sensitive",
			renderer = {
				group_empty = true,
			},
			view = {
				adaptive_size = true,
				side = "left",
			},
		})
	end,
}
