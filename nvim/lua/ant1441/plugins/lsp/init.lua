return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
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
