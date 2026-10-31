-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- See: set.lua

-- Setup lazy.nvim

local spec = {
    { import = "ant1441.plugins" },
    { import = "ant1441.plugins.lsp" },
}

-- Machine/work-specific plugins, not tracked in git
local local_plugins = vim.fn.stdpath("config") .. "/lua/ant1441/local/plugins"
if vim.uv.fs_stat(local_plugins) then
    table.insert(spec, { import = "ant1441.local.plugins" })
end

require("lazy").setup({
    spec = spec,
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "carbonfox" } },
    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})
