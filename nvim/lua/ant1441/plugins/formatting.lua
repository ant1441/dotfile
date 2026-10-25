return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "ruff" },
            rust = { "rustfmt" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            sh = { "shfmt" },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true, -- Ensures LSP fallbacks work if formatters fail
        },
        formatters = {
            shfmt = {
                append_args = { "-i", "2" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
