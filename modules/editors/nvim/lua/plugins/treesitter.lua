return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufRead",
	config = function()
		local configs = require("nvim-treesitter.configs")

		vim.filetype.add({ extension = { wgsl = "wgsl" } })

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.wgsl = {
			install_info = {
				url = "https://github.com/szebniok/tree-sitter-wgsl",
				files = { "src/parser.c" },
			},
		}

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "wgsl" },
			sync_install = false,
			auto_install = true,
			ignore_install = { "" }, -- List of parsers to ignore installing
			autopairs = {
				enable = true,
			},
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "" } },
			rainbow = {
				enable = false,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
