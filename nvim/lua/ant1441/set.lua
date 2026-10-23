vim.g.mapleader = ","

-- Show line numbers
vim.opt.number = true

-- Don't show the mode on switch, as it's in the statusbar
vim.opt.showmode = false

vim.opt.cursorline = true
-- TODO: Toggle for cursorcolumn

vim.opt.termguicolors = true -- Use 24-bit colours [_probably_ neovim default]

-- Don't autowrap on load
vim.opt.wrap = false

-- Highlight tab chars and trailing whitespace
vim.opt.listchars = { tab = "▷⋅", trail = "·", extends = "⇨", precedes = "⇦", nbsp = "Ø" }
vim.opt.list = true

vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 8 -- Set tabs to 8 char wide [neovim default]
vim.opt.shiftwidth = 4 -- Spaces used for (auto)indent
vim.opt.softtabstop = 4 -- Number of spaces a tab counts for when doing editing (ie. when doing a <BS>)

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("ant1441-lua-tabstop", { clear = true }),
	desc = "Set tabstop etc. for Lua",
	pattern = "lua",
	callback = function()
		-- Lua uses tabs (enforced via formatter)
		-- So shrink them, and don't highlight them
		vim.opt.tabstop = 4
		vim.opt.listchars = { tab = "  ", trail = "·", extends = "⇨", precedes = "⇦", nbsp = "Ø" }
	end,
})

vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = true -- Highlight search results [neovim default]
vim.opt.incsearch = true -- Search for a pattern as it is typed [neovim default]
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if the pattern contains upper case letters

vim.opt.spelllang = "en_gb,ga_ie"
-- region ie (en_ie) not supported

-- ignore these files when completing names and in explorer
vim.opt.wildignore = ".svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif"

-- Ensure there is always 4 lines below the cursor (except at EOF)
vim.opt.scrolloff = 4

vim.opt.updatetime = 100

-- Make the escape key more responsive by decreasing the wait time for an
-- escape sequence (e.g., arrow keys).
vim.opt.timeoutlen = 100

vim.opt.colorcolumn = "120"
