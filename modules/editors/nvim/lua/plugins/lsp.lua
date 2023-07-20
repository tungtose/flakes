return {
	"neovim/nvim-lspconfig",
	name = "lspconfig",
	lazy = false,
	dependencies = {
		{ "simrat39/rust-tools.nvim", name = "rust-tools" },
		{ "j-hui/fidget.nvim", name = "fidget" },
	},
	config = function()
		-- Use an on_attach function to only map the following keys
		-- after the language server attaches to the current buffer
		local lsp_formatting = function(bufnr)
			vim.lsp.buf.format({
				filter = function(client)
					-- apply whatever logic you want (in this example, we'll only use null-ls)
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end

		-- if you want to set up formatting on save, you can use this as a callback
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local on_attach = function(client, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>cn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			nmap("<leader>d[", vim.diagnostic.goto_next, "[G]o [N]next")
			nmap("<leader>d]", vim.diagnostic.goto_prev, "[G]o [P]rev")

			nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
			nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			nmap("<leader>F", vim.lsp.buf.format, "[F]ormat [C]ode")

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "F", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })

			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						lsp_formatting(bufnr)
					end,
				})
			end
		end

		-- Add additional capabilities supported by nvim-cmp
		-- nvim hasn't added foldingRange to default capabilities, users must add it manually
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local nvim_lsp = require("lspconfig")

		---------------------
		-- setup languages --
		---------------------
		-- GoLang
		--[[ nvim_lsp["gopls"].setup({ ]]
		--[[ 	on_attach = on_attach, ]]
		--[[ 	capabilities = capabilities, ]]
		--[[ 	settings = { ]]
		--[[ 		gopls = { ]]
		--[[ 			experimentalPostfixCompletions = true, ]]
		--[[ 			analyses = { ]]
		--[[ 				unusedparams = true, ]]
		--[[ 				shadow = true, ]]
		--[[ 			}, ]]
		--[[ 			staticcheck = true, ]]
		--[[ 		}, ]]
		--[[ 	}, ]]
		--[[ 	init_options = { ]]
		--[[ 		usePlaceholders = true, ]]
		--[[ 	}, ]]
		--[[ }) ]]
		-- C
		nvim_lsp.clangd.setup({})

		--Python
		--[[ nvim_lsp.pyright.setup({ ]]
		--[[ 	on_attach = on_attach, ]]
		--[[ 	capabilities = capabilities, ]]
		--[[ 	settings = { ]]
		--[[ 		python = { ]]
		--[[ 			analysis = { ]]
		--[[ 				autoSearchPaths = true, ]]
		--[[ 				diagnosticMode = "workspace", ]]
		--[[ 				useLibraryCodeForTypes = true, ]]
		--[[ 				typeCheckingMode = "off", ]]
		--[[ 			}, ]]
		--[[ 		}, ]]
		--[[ 	}, ]]
		--[[ }) ]]

		--sumneko_lua
		nvim_lsp.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		})

		local rt = require("rust-tools")

		rt.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						-- enable clippy on save
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			},
		})

		--Rust
		--[[ require("rust-tools").setup({ ]]
		--[[ 	server = { ]]
		--[[ 		capabilities = capabilities, ]]
		--[[ 		on_attach = on_attach, ]]
		--[[ 	}, ]]
		--[[ })  ]]

		--[[ nvim_lsp.rust_analyzer.setup({ ]]
		--[[ 	on_attach = on_attach, ]]
		--[[ 	capabilities = capabilities, ]]
		--[[ 	filetypes = { "rust" }, ]]
		--[[ }) ]]

		nvim_lsp.html.setup({
			on_attach = on_attach,
			cmd = { "vscode-html-language-server", "--stdio" },
		})

		nvim_lsp.cssls.setup({
			on_attach = on_attach,
			cmd = { "vscode-css-language-server", "--stdio" },
		})

		--[[ nvim_lsp.zk.setup({ ]]
		--[[ 	cmd = { "zk", "lsp" }, ]]
		--[[ }) ]]
		--[[]]

		nvim_lsp.tsserver.setup({
			on_attach = on_attach,
			cmd = { "typescript-language-server", "--stdio" },
		})

		nvim_lsp.bashls.setup({
			cmd = { "bash-language-server", "start" },
		})

		nvim_lsp.rnix.setup({
			on_attach = on_attach,
		})

		vim.g.syntastic_ebuild_checkers = "pkgcheck"

		-------------
		--Progress --
		-------------

		local fidget = require("fidget")
		fidget.setup()

		--------
		-- UI --
		--------
		--Change diagnostic symbols in the sign column (gutter)
		local signs = { Error = "", Warn = "", Hint = "󰅾", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
		vim.diagnostic.config({
			-- virtual_text = {
			-- 	source = "always", -- Or "if_many"
			-- },
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = true,
			severity_sort = false,
			float = {
				source = "always", -- Or "if_many"
			},
		})
	end,
}
