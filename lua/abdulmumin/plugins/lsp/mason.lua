return {
	"williamboman/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

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
				-- Core web technologies
				-- Removed "ts_ls" as "vtsls" handles TypeScript/JavaScript for Vue projects
				"html", -- HTML
				"cssls", -- CSS
				"tailwindcss", -- TailwindCSS
				"emmet_ls", -- Emmet
				"eslint", -- ESLint
				"vtsls", -- TypeScript/JavaScript (Volar's TS server, handles all TS/JS needs)

				-- Frameworks
				"vue_ls", -- Vue (official)

				-- Other languages
				"lua_ls", -- Lua
				"gopls", -- Go
				"pyright", -- Python

				-- Specialized
				"graphql", -- GraphQL
				"dockerls", -- Docker
				"jsonls", -- JSON
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"prettier", -- JS/TS/Vue/React formatter
				"prettierd", -- Faster prettier
				"stylua", -- Lua formatter
				"isort", -- Python import sorter
				"gofumpt", -- Go formatter
				"goimports", -- Go import formatter
				"golines", -- Go line length formatter

				-- Linters
				"eslint_d", -- Fast ESLint
				"pylint", -- Python linter
				"mypy", -- Python type checker
				"golangci-lint", -- Go linter

				-- Debug adapters
				"debugpy", -- Python debugger

				-- Other tools
				"ruff", -- Fast Python linter/formatter
				"sqlfmt", -- SQL formatter
			},
		})
	end,
}
