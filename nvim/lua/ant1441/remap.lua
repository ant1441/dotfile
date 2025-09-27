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

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Formating
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer", remap = true })

-- LSP
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

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

-- Only enable these if there is an active LSP server
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("ant1441-lsp-attach", { clear = true }),
	desc = "LSP actions",
	callback = function(event)
		local keymap_set = function(keys, action, desc, mode)
			mode = mode or "n"
			desc = "LSP: " .. desc
			local opts = { buffer = event.buf, desc = desc }
			assert(action ~= nil, "Action given for keymap " .. keys .. " shouldn't be nil")
			vim.keymap.set(mode, keys, action, opts)
		end

		keymap_set("K", vim.lsp.buf.hover, "Hover")
		keymap_set("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		keymap_set("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		keymap_set("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		keymap_set("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
		keymap_set("gr", vim.lsp.buf.references, "[G]et [R]eferences")
		keymap_set("gs", vim.lsp.buf.signature_help, "[G]et [S]ignature")
		keymap_set("<leader>r", vim.lsp.buf.rename, "[R]ename")
		keymap_set("<leader>a", vim.lsp.buf.code_action, "Code Actions")
		keymap_set("<A-cr>a", vim.lsp.buf.code_action, "Code Actions")
		keymap_set("<leader>e", vim.diagnostic.open_float, "Show diagnostics")

		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
		---@param client vim.lsp.Client
		---@param method vim.lsp.protocol.Method
		---@param bufnr? integer some lsp support methods only in specific files
		---@return boolean
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				---@diagnostic disable-next-line: param-type-mismatch
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("ant1441-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("ant1441-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "ant1441-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		keymap_set("<leader>th", function()
			if
				client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
			then
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			else
				vim.notify("Inlay Hints not available", vim.log.levels.INFO)
			end
		end, "[T]oggle Inlay [H]ints")
	end,
})
