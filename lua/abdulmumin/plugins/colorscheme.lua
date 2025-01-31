return {
	-- Catppuccin (higher priority and appears first)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Higher priority than Tokyo Night
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = {
					light = "latte",
					dark = "mocha",
				},
			})
			vim.cmd("colorscheme catppuccin") -- Set Catppuccin as the default
		end,
	},
	-- Tokyo Night (lower priority and appears second)
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Lower priority than Catppuccin
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
	-- Toggle functionality
	{
		"nvim-lua/plenary.nvim", -- Optional, but useful for some utility functions
		config = function()
			local colorscheme = "catppuccin" -- Default colorscheme

			-- Function to update lualine theme
			local update_lualine_theme = function()
				require("lualine").setup({
					options = {
						theme = colorscheme, -- Use the colorscheme name as the lualine theme
					},
				})
			end

			-- Function to toggle between Tokyo Night and Catppuccin
			local toggle_colorscheme = function()
				if colorscheme == "tokyonight" then
					colorscheme = "catppuccin"
				else
					colorscheme = "tokyonight"
				end
				vim.cmd("colorscheme " .. colorscheme)
				update_lualine_theme() -- Update lualine theme after toggling
				print("Colorscheme set to: " .. colorscheme)
			end

			-- Set the initial colorscheme
			vim.cmd("colorscheme " .. colorscheme)
			update_lualine_theme() -- Set the initial lualine theme

			-- Keymap to toggle between colorschemes
			vim.keymap.set(
				"n",
				"<leader>ct",
				toggle_colorscheme,
				{ noremap = true, silent = true, desc = "Toggle colorscheme" }
			)
		end,
	},
}
