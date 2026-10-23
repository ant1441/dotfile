return {
    {
        "EdenEast/nightfox.nvim",

        -- the colorscheme should be available when starting Neovim
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins

        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme carbonfox]])
        end,
    },
}
