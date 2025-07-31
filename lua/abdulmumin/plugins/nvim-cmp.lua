return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*", -- follow latest release
			build = "make install_jsregexp", -- optional build step
		},
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- VS Code-like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		-- Load VS Code-style snippets from installed plugins
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Helper function to check if we're in a snippet
		local in_snippet = function()
			return luasnip.in_snippet()
		end

		-- Helper function to check for Copilot
		local has_copilot_suggestion = function()
			local ok, suggestion = pcall(require, "copilot.suggestion")
			return ok and suggestion.is_visible()
		end

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- Configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),

				-- More predictable Tab behavior
				["<Tab>"] = cmp.mapping(function(fallback)
					-- Priority 1: If completion menu is visible, navigate
					if cmp.visible() then
						cmp.select_next_item()
					-- Priority 2: If we're actively in a snippet, jump to next placeholder
					elseif in_snippet() and luasnip.jumpable(1) then
						luasnip.jump(1)
					-- Priority 3: Everything else gets normal Tab (indentation)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif in_snippet() and luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Optional: Use Ctrl+L for snippet expansion/jump when not in completion
				["<C-l>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Optional: Use Ctrl+H for jumping backward in snippets
				["<C-h>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol_text", -- Options: 'text', 'symbol', 'symbol_text'
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})

		-- Optional: Set up command line completion
		-- cmp.setup.cmdline(':', {
		-- 	mapping = cmp.mapping.preset.cmdline(),
		-- 	sources = cmp.config.sources({
		-- 		{ name = 'path' }
		-- 	}, {
		-- 		{ name = 'cmdline' }
		-- 	})
		-- })

		-- cmp.setup.cmdline('/', {
		-- 	mapping = cmp.mapping.preset.cmdline(),
		-- 	sources = {
		-- 		{ name = 'buffer' }
		-- 	}
		-- })
	end,
}
