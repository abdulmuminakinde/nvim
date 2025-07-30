return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			awk = { "gawk" },
			go = { "golangcilint" }, -- Correct reference to our custom linter
			html = { "tidy" },
			javascript = { "eslint_d" },
			python = { "ruff" },
			typescript = { "eslint_d" },
			json = { "jsonlint" },
			make = { "checkmake" },
			markdown = { "alex", "markdownlint", "woke" },
			rust = { "clippy" },
			sh = { "bash", "shellcheck" },
			zsh = { "shellcheck", "zsh" },
			yaml = { "yamllint" },
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
