local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find git files" })
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string()
end, { desc = "Telescope find files" })
