return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local lspconfig = require("lspconfig") -- Import lspconfig

		local keymap = vim.keymap -- for conciseness
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", function()
					require("telescope.builtin").lsp_references({ reuse_win = true })
				end, opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", function()
					require("telescope.builtin").lsp_definitions({ reuse_win = true })
				end, opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", function()
					require("telescope.builtin").lsp_implementations({ reuse_win = true })
				end, opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", function()
					require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
				end, opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", function()
					require("telescope.builtin").diagnostics({ bufnr = 0 })
				end, opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		-- Generic LSP configuration, applied to all servers by default
		-- Individual server configs below will override or extend this.
		lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
			capabilities = capabilities,
		})

		-- Go Language Server (gopls)
		lspconfig.gopls.setup({
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		})

		-- VTSLS (TypeScript/JavaScript with Vue support)
		-- This handles all TS/JS/Vue files with proper TypeScript integration
		lspconfig.vtsls.setup({
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				hostInfo = "neovim",
			},
			settings = {
				complete_function_calls = true,
				vtsls = {
					enableMoveToFileCodeAction = true,
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							enableServerSideFuzzyMatch = true,
						},
					},
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
				typescript = {
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = true,
					},
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = false },
					},
				},
				javascript = {
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = true,
					},
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = false },
					},
				},
			},
		})

		-- Vue Language Server (DISABLED to prevent conflicts with vtsls)
		-- We're using vtsls with Vue TypeScript plugin instead for better TS integration
		-- lspconfig.vue_ls.setup({
		-- 	autostart = false, -- Disabled to prevent conflicts
		-- })

		-- Tailwind CSS Language Server
		lspconfig.tailwindcss.setup({
			filetypes = {
				"html",
				"css",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"scss",
				"less",
				"astro", -- Add if you use Astro
				"php", -- Add if you use PHP with Tailwind
				"erb", -- Add if you use Ruby on Rails with Tailwind
				"blade", -- Add if you use Laravel Blade with Tailwind
			},
		})

		-- Nuxt Language Server
		lspconfig.nuxt.setup({
			filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
		})

		-- GraphQL Language Server
		lspconfig.graphql.setup({
			filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact", "vue" },
		})

		-- Emmet Language Server
		lspconfig.emmet_ls.setup({
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "vue" },
		})

		-- ESLint Language Server
		lspconfig.eslint.setup({
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "vue" },
		})

		-- Lua Language Server
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false, -- Disable checking of third-party libraries
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
}
