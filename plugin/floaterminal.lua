local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf
	if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window()
		vim.cmd.terminal()
	else
		vim.api.nvim_win_hide(state.floating.win)
	end

	-- Ensure we're in insert mode for the terminal
	if vim.fn.mode() ~= "i" then
		vim.cmd("startinsert")
	end
end

-- Create user commands
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

-- Keybindings
vim.keymap.set("n", "<C-t>", ":Floaterminal<CR>", { noremap = true, silent = true }) -- Alt+T for terminal
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:Floaterminal<CR>", { noremap = true, silent = true }) -- Alt+T in terminal mode
