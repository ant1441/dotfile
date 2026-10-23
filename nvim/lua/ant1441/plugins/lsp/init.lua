return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.enable('ty')

    ----------------------------------------------------------------------
    -- Lua LSP configuration
    ----------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Enable Lua LSP
    -- vim.lsp.enable("lua_ls")
  end
}
