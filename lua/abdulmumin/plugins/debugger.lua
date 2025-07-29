return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"leoluz/nvim-dap-go",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- Initialize plugins
			dapui.setup()
			require("dap-go").setup({
				-- Configure delve for CLI interactivity
				dap_configurations = {
					{
						type = "go",
						name = "Debug CLI Application",
						request = "launch",
						program = "${file}",
						console = "integratedTerminal", -- This enables terminal input
						args = function()
							-- Prompt for command line arguments
							local args_string = vim.fn.input("Command line arguments: ")
							return vim.split(args_string, " ")
						end,
					},
					{
						type = "go",
						name = "Connect to Remote",
						request = "attach",
						mode = "remote",
						host = function()
							return vim.fn.input("Remote host: ")
						end,
						port = function()
							return tonumber(vim.fn.input("Remote port: "))
						end,
					},
				},
			})

			-- Configure DAP event listeners
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Fix: Change DapUiToggle to use Lua function instead of a command
			vim.keymap.set("n", "<Leader>dt", function()
				dapui.toggle()
			end, { desc = "Toggle DAP UI" })

			-- Existing keymaps
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
			vim.keymap.set("n", "<Leader>dr", function()
				dapui.open({ reset = true })
			end, { desc = "Reset DAP UI" })

			-- Added stepping keymaps
			vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<Leader>dO", dap.step_out, { desc = "Step Out" })

			-- Add Go test debugging
			vim.keymap.set("n", "<Leader>dgt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug Go Test" })

			-- Add keymaps for specialized debug launches
			vim.keymap.set("n", "<Leader>dcli", function()
				dap.run({
					type = "go",
					name = "Debug CLI Application",
					request = "launch",
					program = vim.fn.expand("%:p"),
					console = "integratedTerminal",
					args = vim.split(vim.fn.input("Arguments: "), " "),
				})
			end, { desc = "Debug CLI App" })

			-- Add remote debugging keymap
			vim.keymap.set("n", "<Leader>dra", function()
				local host = vim.fn.input("Remote host: ")
				local port = tonumber(vim.fn.input("Remote port: "))
				dap.run({
					type = "go",
					name = "Connect to Remote",
					request = "attach",
					mode = "remote",
					host = host,
					port = port,
				})
			end, { desc = "Debug Remote App" })

			-- Add remote debugging keymap with configurable program arguments
			vim.keymap.set("n", "<Leader>drc", function()
				local host = vim.fn.input("Remote host (default: localhost): ")
				if host == "" then
					host = "127.0.0.1"
				end

				local port = vim.fn.input("Remote port (default: 2345): ")
				if port == "" then
					port = "2345"
				end

				require("dap").run({
					type = "go",
					name = "Attach to headless session",
					request = "attach",
					mode = "remote",
					host = host,
					port = tonumber(port),
				})
			end, { desc = "Connect to headless delve" })

			-- Breakpoint appearance
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "Error", linehl = "CursorLine", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "String", linehl = "DiffAdd", numhl = "" })
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui", -- Added dependency for UI support
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
			require("dap-python").setup(path)

			local dap = require("dap")

			-- Add Python module debugging configurations
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "Debug Python Module",
				module = function()
					return vim.fn.input("Module name: ")
				end,
				args = function()
					local args_string = vim.fn.input("Arguments: ")
					return vim.split(args_string, " ")
				end,
				pythonPath = function()
					return path
				end,
				cwd = "${workspaceFolder}",
				env = {
					PYTHONPATH = "${workspaceFolder}",
				},
				console = "integratedTerminal",
			})

			-- Specific configuration for litelookup module
			table.insert(dap.configurations.python, {
				type = "python",
				request = "launch",
				name = "Debug litelookup",
				module = "litelookup.main",
				args = function()
					local args_string = vim.fn.input("Arguments: ")
					return vim.split(args_string, " ")
				end,
				pythonPath = function()
					return path
				end,
				cwd = "${workspaceFolder}",
				env = {
					PYTHONPATH = "${workspaceFolder}",
				},
				console = "integratedTerminal",
			})

			-- Remote debugging configuration for Python
			table.insert(dap.configurations.python, {
				type = "python",
				request = "attach",
				name = "Attach to Python process",
				connect = {
					host = function()
						return vim.fn.input("Host [localhost]: ", "127.0.0.1")
					end,
					port = function()
						return tonumber(vim.fn.input("Port [5678]: ", "5678"))
					end,
				},
				pathMappings = {
					{
						localRoot = "${workspaceFolder}",
						remoteRoot = ".",
					},
				},
			})

			-- Add Python-specific debugging keymaps
			vim.keymap.set("n", "<leader>dpm", function()
				local module = vim.fn.input("Module name: ")
				local args_string = vim.fn.input("Arguments: ")
				dap.run({
					type = "python",
					request = "launch",
					name = "Debug Python Module",
					module = module,
					args = vim.split(args_string, " "),
					pythonPath = path,
					cwd = "${workspaceFolder}",
					env = {
						PYTHONPATH = "${workspaceFolder}",
					},
					console = "integratedTerminal",
				})
			end, { desc = "Debug Python Module" })

			-- Debug litelookup keymap
			vim.keymap.set("n", "<leader>dpl", function()
				local args_string = vim.fn.input("Arguments: ")
				dap.run({
					type = "python",
					request = "launch",
					name = "Debug litelookup",
					module = "litelookup.main",
					args = vim.split(args_string, " "),
					pythonPath = path,
					cwd = "${workspaceFolder}",
					env = {
						PYTHONPATH = "${workspaceFolder}",
					},
					console = "integratedTerminal",
				})
			end, { desc = "Debug litelookup" })

			-- Attach to Python process keymap
			vim.keymap.set("n", "<leader>dpa", function()
				local host = vim.fn.input("Host [localhost]: ", "localhost")
				local port = tonumber(vim.fn.input("Port [5678]: ", "5678"))
				dap.run({
					type = "python",
					request = "attach",
					name = "Attach to Python process",
					connect = {
						host = host,
						port = port,
					},
					pathMappings = {
						{
							localRoot = "${workspaceFolder}",
							remoteRoot = ".",
						},
					},
				})
			end, { desc = "Attach to Python process" })
		end,
	},
}
