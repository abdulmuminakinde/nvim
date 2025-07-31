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
				-- Simplified Python setup - ruff can handle both import sorting and formatting
				python = { "ruff_format", "ruff_organize_imports" },
				-- Alternative Python setup if you prefer black:
				-- python = { "isort", "black" },
				sql = { "sqlfmt" }, -- sqlfmt works better with stdin
				go = { "goimports", "gofmt" }, -- Using built-in Go formatters
				-- Vue with proper formatter
				vue = { "prettier" },
				-- Additional file types
				rust = { "rustfmt" },
				sh = { "shfmt" },
				toml = { "taplo" },
			},
			-- Single format_on_save configuration (remove the autocmd)
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},
			-- Custom formatter configurations if needed
			formatters = {
				-- Example: customize prettier for specific needs
				prettier = {
					options = {
						ft_parsers = {
							vue = "vue",
						},
					},
				},
				-- If you still want to use sql-formatter instead of sqlfmt:
				-- sql_formatter = {
				--   command = "sql-formatter",
				--   args = { "-l", "postgresql", "--fix" },
				--   stdin = true, -- Let conform handle stdin
				-- },
			},
		})

		-- Manual formatting keymap
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		-- Optional: Add a keymap to format without LSP fallback
		vim.keymap.set({ "n", "v" }, "<leader>mf", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 3000,
			})
		end, { desc = "Format with conform only (no LSP)" })
	end,
}
