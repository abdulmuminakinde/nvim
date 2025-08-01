return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects", -- Add textobjects
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")
		-- configure treesitter
		treesitter.setup({
			-- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"python",
				"go",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"sql",
				"markdown_inline",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"vue",
				"toml",
				"proto",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "gns", -- s for "select more"
					scope_incremental = "gnc", -- c for "class/scope"
					node_decremental = "gnx", -- x for "shrink/less"
				},
			},
			-- Add textobjects configuration
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["a/"] = "@comment.outer",
						["i/"] = "@comment.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["as"] = "@statement.outer",
						["is"] = "@statement.inner",
						["ad"] = "@call.outer",
						["id"] = "@call.inner",
						["am"] = "@call.outer", -- method call
						["im"] = "@call.inner", -- method call
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
						["]o"] = "@loop.*",
						["]s"] = "@statement.outer",
						["]b"] = "@block.outer",
						["]i"] = "@conditional.outer",
						["]d"] = "@call.outer",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
						["]O"] = "@loop.*",
						["]S"] = "@statement.outer",
						["]B"] = "@block.outer",
						["]I"] = "@conditional.outer",
						["]D"] = "@call.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
						["[o"] = "@loop.*",
						["[s"] = "@statement.outer",
						["[b"] = "@block.outer",
						["[i"] = "@conditional.outer",
						["[d"] = "@call.outer",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
						["[O"] = "@loop.*",
						["[S"] = "@statement.outer",
						["[B"] = "@block.outer",
						["[I"] = "@conditional.outer",
						["[D"] = "@call.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}
