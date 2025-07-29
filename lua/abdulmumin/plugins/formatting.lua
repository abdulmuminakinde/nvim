return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "ruff", "black" },
				sql = { "sql_formatter" }, -- Using sql-formatter for SQL files
				go = { "golines", "gofumpt" },
			},
			formatters = {
				-- Go formatters
				-- ["goimports-reviser"] = {
				-- 	command = "goimports-reviser",
				-- 	args = { "-rm-unused", "-set-alias", "-format", "$FILENAME" },
				-- 	stdin = false,
				-- },
				golines = {
					command = "golines",
					args = { "-w", "$FILENAME" },
					stdin = false,
				},
				gofumpt = {
					command = "gofumpt",
					args = { "-w", "$FILENAME" },
					stdin = false,
				},
				-- SQL Formatter configuration
				sql_formatter = {
					command = "sql-formatter",
					args = { "-l", "postgresql" }, -- Specify SQL dialect
					stdin = false,
				},
			},
		})

		-- Keybinding for manual formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 2000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Auto-format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 2000, -- Adjust timeout as needed
				})
			end,
		})
	end,
}
