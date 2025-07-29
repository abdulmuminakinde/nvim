return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"jsonls",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"dockerls",
				"pyright",
				"gopls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"mypy",
				"debugpy",
				"ruff", -- python formatte
				"black",
				"eslint_d",
				"golangci-lint",
				"golines",
				"goimports",
				"gofumpt",
				"sqlfmt",
			},
		})

		-- LSP Configuration
		local keymap = vim.keymap

		-- Create a common on_attach function
		local function common_on_attach(client, bufnr)
			-- Buffer local mappings.
			local opts = { buffer = bufnr, silent = true }

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts)

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		end

		-- used to enable autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

		local config = {
			signs = {
				active = signs,
			},
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focused = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
			virtual_text = {
				prefix = "●",
				spacing = 2,
			},
		}

		vim.diagnostic.config(config)

		-- Setup LSP handlers - check if setup_handlers exists first
		if mason_lspconfig.setup_handlers then
			mason_lspconfig.setup_handlers({
				-- default handler
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
					})
				end,

				-- GraphQL configuration
				["graphql"] = function()
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,

				-- Emmet configuration
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						filetypes = {
							"html",
							"typescript",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,

				-- Go configuration
				["gopls"] = function()
					lspconfig["gopls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
								gofumpt = true,
								completeUnimported = true,
								usePlaceholders = true,
							},
						},
					})
				end,

				-- Python configuration
				["pyright"] = function()
					lspconfig["pyright"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "openFilesOnly",
								},
								exclude = { "venv", ".venv", "build", "dist", "__pycache__" },
							},
						},
					})
				end,

				-- Lua configuration
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
			})
		else
			-- Fallback: manually set up LSP servers if setup_handlers doesn't exist
			local installed_servers = mason_lspconfig.get_installed_servers()
			for _, server_name in pairs(installed_servers) do
				if server_name == "graphql" then
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				elseif server_name == "emmet_ls" then
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						filetypes = {
							"html",
							"typescript",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				elseif server_name == "gopls" then
					lspconfig["gopls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
								gofumpt = true,
								completeUnimported = true,
								usePlaceholders = true,
							},
						},
					})
				elseif server_name == "pyright" then
					lspconfig["pyright"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "openFilesOnly",
								},
								exclude = { "venv", ".venv", "build", "dist", "__pycache__" },
							},
						},
					})
				elseif server_name == "lua_ls" then
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				else
					-- Default setup for other servers
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = common_on_attach,
					})
				end
			end
		end
	end,
}
