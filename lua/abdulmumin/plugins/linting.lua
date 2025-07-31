return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Comprehensive linter configuration
		lint.linters_by_ft = {
			awk = { "gawk" },
			go = { "golangcilint" },
			html = { "tidy" },
			javascript = { "eslint_d" },
			python = { "ruff" }, -- Using ruff instead of pylint for better performance
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

		-- Helper functions for conditional linting
		local function file_in_cwd(file_name)
			return vim.fs.find(file_name, {
				upward = true,
				stop = vim.loop.cwd():match("(.+)/"),
				path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				type = "file",
			})[1]
		end

		local function remove_linter(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					linters[k] = nil
					break
				end
			end
		end

		local function linter_in_linters(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					return true
				end
			end
			return false
		end

		local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
			if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
				remove_linter(linters, linter_name)
			end
		end

		-- Enhanced try_linting with conditional logic
		local function try_linting()
			local linters = lint.linters_by_ft[vim.bo.filetype]
			if linters then
				-- Make a copy to avoid modifying the original
				local active_linters = vim.deepcopy(linters)

				-- Conditional linter removal based on config files
				remove_linter_if_missing_config_file(active_linters, "eslint_d", "eslint.config.js")
				remove_linter_if_missing_config_file(active_linters, "eslint_d", ".eslintrc.js")
				remove_linter_if_missing_config_file(active_linters, "eslint_d", ".eslintrc.json")
				remove_linter_if_missing_config_file(active_linters, "yamllint", ".yamllint")
				remove_linter_if_missing_config_file(active_linters, "markdownlint", ".markdownlint.json")
				remove_linter_if_missing_config_file(active_linters, "golangcilint", ".golangci.yml")

				lint.try_lint(active_linters)
			else
				lint.try_lint()
			end
		end

		-- Auto-commands for linting
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				try_linting()
			end,
		})

		-- Manual linting keymap
		vim.keymap.set("n", "<leader>l", function()
			try_linting()
		end, { desc = "Trigger linting for current file" })
	end,
}
