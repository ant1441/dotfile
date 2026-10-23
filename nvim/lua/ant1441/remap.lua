vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

-- Move lines up & down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Window movement
vim.keymap.set({ "n", "v", "o" }, "<C-j>", "<c-w>j")
vim.keymap.set({ "n", "v", "o" }, "<C-k>", "<c-w>k")
vim.keymap.set({ "n", "v", "o" }, "<C-l>", "<c-w>l")
vim.keymap.set({ "n", "v", "o" }, "<C-h>", "<c-w>h")

-- Ensure search results are always in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Open File browser
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = "Open Directory" })

-- Yank into system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>yy", [["+yy]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Disable Ex mode (now multicursor)
-- vim.keymap.set("n", "Q", "<nop>")

-- Formating
-- vim.keymap.set("n", "<leader>f", function()
-- 	require("conform").format({ async = true, lsp_format = "fallback" })
-- end, { desc = "[F]ormat buffer", remap = true })

-- LSP
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>") -- TODO: deprecated
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>") -- TODO: deprecated

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<A-l>", vim.cmd.BufferNext, { desc = "Next buffer" })
vim.keymap.set("n", "<A-h>", vim.cmd.BufferPrevious, { desc = "Previous buffer" })
vim.keymap.set("n", "<C-A-l>", vim.cmd.BufferMoveNext, { desc = "Move buffer right" })
vim.keymap.set("n", "<C-A-h>", vim.cmd.BufferMovePrevious, { desc = "Move buffer left" })

vim.keymap.set("n", "<A-c>", vim.cmd.BufferClose, { desc = "Close buffer" })
vim.keymap.set("n", "<A-S-c>", vim.cmd.BufferRestore, { desc = "Restore buffer" })

vim.keymap.set("n", "<A-p>", vim.cmd.BufferPick, { desc = "Pick buffer" })

vim.keymap.set("n", "<A-S-p>", vim.cmd.BufferPin, { desc = "Pick buffer" })

-- vim.keymap.set("n", "<A-1>", vim.cmd.BufferGoto(1), { desc = "Go to buffer 1" })
