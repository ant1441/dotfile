return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    event = 'VeryLazy',

    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
        animation = false,
        auto_hide = true,
        icons = {
            -- diagnostics = {
            --     -- NOTE: This might be a bit noisy?
            --     [vim.diagnostic.severity.ERROR] = { enabled = true },
            --     [vim.diagnostic.severity.WARN] = { enabled = true },
            --     [vim.diagnostic.severity.INFO] = { enabled = true },
            --     [vim.diagnostic.severity.HINT] = { enabled = true },
            -- },
            gitsigns = {
                added = { enabled = true, icon = "+" },
                changed = { enabled = true, icon = "~" },
                deleted = { enabled = true, icon = "-" },
            },
            pinned = { button = "", filename = true },
            preset = "slanted",
        },
    },
}
