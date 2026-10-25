-- TODO: telescope.load_extension("ui-select")
--
-- Some inspiration from LazyVim - https://www.lazyvim.org/extras/editor/telescope#telescopenvim

-- A cache for a git lookup
local is_inside_work_tree = {}

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-symbols.nvim",
		},
		cmd = "Telescope",
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Load extensions AFTER setup
			telescope.load_extension("fzf")
		end,
		keys = {
			{
				"<leader>ps",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "Telescope grep string",
			},
			{
				"<leader>pg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Telescope live grep",
			},
			{
				"<leader>:",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			-- Finders
			{
				"<C-p>",
				function()
					local opts = {}

					local cwd = vim.fn.getcwd()
					if is_inside_work_tree[cwd] == nil then
						vim.fn.system("git rev-parse --is-inside-work-tree")
						is_inside_work_tree[cwd] = vim.v.shell_error == 0
					end

					if is_inside_work_tree[cwd] then
						require("telescope.builtin").git_files(opts)
					else
						require("telescope.builtin").find_files(opts)
					end
				end,
				desc = "Telescope find git files",
			},
			{ "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Buffers (all)" },
			{
				"<leader>fc",
				function()
					local opts = {
						search_dirs = { vim.fn.stdpath("config") },
					}
					require("telescope.builtin").find_files(opts)
				end,
				desc = "Find Config File",
			},
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			-- Symbols
			{ "<leader>fs", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
			{ "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
		},
	},
}
