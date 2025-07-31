return {
	-- Colorscheme plugins
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		priority = 1000,
		config = function()
			require("solarized-osaka").setup({
				-- Optional configuration
				transparent = false,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
				hide_inactive_statusline = false, -- Enabling this option will hide inactive statuslines and replace them with a thin border instead
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
			})
		end,
	},
	-- Colorscheme toggle functionality
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local colorschemes = { "catppuccin", "tokyonight", "solarized-osaka" }
			local current_index = 1 -- Start with catppuccin

			-- Function to update lualine theme
			local update_lualine_theme = function(theme)
				local ok, lualine = pcall(require, "lualine")
				if ok then
					lualine.setup({
						options = {
							theme = theme == "solarized-osaka" and "solarized_dark" or theme,
						},
					})
				end
			end

			-- Function to cycle through colorschemes
			local cycle_colorscheme = function()
				current_index = current_index % #colorschemes + 1
				local colorscheme = colorschemes[current_index]

				vim.cmd("colorscheme " .. colorscheme)
				update_lualine_theme(colorscheme)
				print("Colorscheme set to: " .. colorscheme)
			end

			-- Set the initial colorscheme
			local initial_colorscheme = colorschemes[current_index]
			vim.cmd("colorscheme " .. initial_colorscheme)
			update_lualine_theme(initial_colorscheme)

			-- Keymap to cycle through colorschemes
			vim.keymap.set(
				"n",
				"<leader>ct",
				cycle_colorscheme,
				{ noremap = true, silent = true, desc = "Cycle colorschemes" }
			)

			-- Optional: Add individual keymaps for direct switching
			vim.keymap.set("n", "<leader>c1", function()
				current_index = 1
				vim.cmd("colorscheme " .. colorschemes[1])
				update_lualine_theme(colorschemes[1])
				print("Colorscheme set to: " .. colorschemes[1])
			end, { desc = "Set Catppuccin" })

			vim.keymap.set("n", "<leader>c2", function()
				current_index = 2
				vim.cmd("colorscheme " .. colorschemes[2])
				update_lualine_theme(colorschemes[2])
				print("Colorscheme set to: " .. colorschemes[2])
			end, { desc = "Set Tokyo Night" })

			vim.keymap.set("n", "<leader>c3", function()
				current_index = 3
				vim.cmd("colorscheme " .. colorschemes[3])
				update_lualine_theme(colorschemes[3])
				print("Colorscheme set to: " .. colorschemes[3])
			end, { desc = "Set Solarized Osaka" })
		end,
	},
}
