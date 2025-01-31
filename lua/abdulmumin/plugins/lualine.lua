return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- Custom Tokyo Night colors for lualine
		local tokyo_night_colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
		}

		-- Custom Catppuccin colors for lualine
		local catppuccin_colors = {
			blue = "#89B4FA",
			green = "#A6E3A1",
			violet = "#CBA6F7",
			yellow = "#F9E2AF",
			red = "#F38BA8",
			fg = "#CDD6F4",
			bg = "#1E1E2E",
			inactive_bg = "#45475A",
		}

		-- Function to get the appropriate lualine theme based on the active colorscheme
		local get_lualine_theme = function()
			if vim.g.colors_name == "catppuccin" then
				return {
					normal = {
						a = { bg = catppuccin_colors.blue, fg = catppuccin_colors.bg, gui = "bold" },
						b = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
					},
					insert = {
						a = { bg = catppuccin_colors.green, fg = catppuccin_colors.bg, gui = "bold" },
						b = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
					},
					visual = {
						a = { bg = catppuccin_colors.violet, fg = catppuccin_colors.bg, gui = "bold" },
						b = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
					},
					command = {
						a = { bg = catppuccin_colors.yellow, fg = catppuccin_colors.bg, gui = "bold" },
						b = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
					},
					replace = {
						a = { bg = catppuccin_colors.red, fg = catppuccin_colors.bg, gui = "bold" },
						b = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.bg, fg = catppuccin_colors.fg },
					},
					inactive = {
						a = { bg = catppuccin_colors.inactive_bg, fg = catppuccin_colors.fg, gui = "bold" },
						b = { bg = catppuccin_colors.inactive_bg, fg = catppuccin_colors.fg },
						c = { bg = catppuccin_colors.inactive_bg, fg = catppuccin_colors.fg },
					},
				}
			else
				return {
					normal = {
						a = { bg = tokyo_night_colors.blue, fg = tokyo_night_colors.bg, gui = "bold" },
						b = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
					},
					insert = {
						a = { bg = tokyo_night_colors.green, fg = tokyo_night_colors.bg, gui = "bold" },
						b = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
					},
					visual = {
						a = { bg = tokyo_night_colors.violet, fg = tokyo_night_colors.bg, gui = "bold" },
						b = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
					},
					command = {
						a = { bg = tokyo_night_colors.yellow, fg = tokyo_night_colors.bg, gui = "bold" },
						b = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
					},
					replace = {
						a = { bg = tokyo_night_colors.red, fg = tokyo_night_colors.bg, gui = "bold" },
						b = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.bg, fg = tokyo_night_colors.fg },
					},
					inactive = {
						a = { bg = tokyo_night_colors.inactive_bg, fg = tokyo_night_colors.fg, gui = "bold" },
						b = { bg = tokyo_night_colors.inactive_bg, fg = tokyo_night_colors.fg },
						c = { bg = tokyo_night_colors.inactive_bg, fg = tokyo_night_colors.fg },
					},
				}
			end
		end

		-- Function to update lualine with the current theme
		local update_lualine_theme = function()
			lualine.setup({
				options = {
					theme = get_lualine_theme(),
				},
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
				},
			})
		end

		-- Set the initial lualine theme
		update_lualine_theme()

		-- Watch for colorscheme changes and update lualine
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = update_lualine_theme,
		})
	end,
}
