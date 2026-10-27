-- Ensure these Language servers are always installed
local ensure_installed_lsp = {
    -- Bash
    "bashls",

    -- Lua
    "lua_ls",

    -- Python
    "ruff",
    "ty",

    -- Rust
    "rust_analyzer",

    -- Terraform
    "tflint",
    "terraformls",
}

return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        ensure_installed = ensure_installed_lsp,
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
