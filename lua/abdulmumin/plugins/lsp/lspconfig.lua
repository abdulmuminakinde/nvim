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
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

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
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
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

		-- Vue Language Server (vue_ls, formerly Volar)
		-- This server requires 'vtsls' for its core TypeScript language services.
		-- Ensure 'vtsls' is installed (e.g., via `npm install -g @volar/vtsls` or Mason).
		lspconfig.vue_ls.setup({
			filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
			-- The 'on_attach' is usually not needed for basic setup if vtsls is found.
			-- If you still face issues, consider explicit client enabling or path configuration.
		})

		-- Volar TypeScript Language Server (vtsls)
		-- This is the dedicated TypeScript language server required by vue_ls.
		-- It handles TypeScript/JavaScript features within Vue files and other JS/TS files.
		lspconfig.vtsls.setup({
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				hostInfo = "neovim",
			},
		})

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
			-- You might want to add settings like these for custom CSS files
			-- settings = {
			--     tailwindCSS = {
			--         lint = {
			--             cssValidation = "warn",
			--             invalidApply = "error",
			--             invalidConfigPath = "error",
			--             invalidScreen = "error",
			--             invalidVariant = "error",
			--             recommendedVariants = "warn",
			--             unsupportedCssProperty = "warn",
			--         },
			--     },
			-- },
		})

		-- Nuxt Language Server
		lspconfig.nuxt.setup({
			filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
			-- You might need to adjust settings based on your Nuxt project structure
			-- settings = {
			--     nuxt = {
			--         -- Example settings, adjust as needed
			--         telemetry = false,
			--     },
			-- },
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
