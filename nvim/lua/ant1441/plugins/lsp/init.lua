return {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        ----------------------------------------------------------------------
        -- Lua LSP configuration
        ----------------------------------------------------------------------
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    workspace = {
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                },
            },
        })
    end,
}
