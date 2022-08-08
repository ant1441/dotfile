local lspconfig = require('lspconfig')

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--     capabilities = capabilities
-- }

-- Examples at https://gist.github.com/equalis3r/ca1fe0266b18be5893b2d9605b492a3b
local lsp_attach = function(client, buf)
    -- Example maps, set your own with vim.api.nvim_buf_set_keymap(buf, "n", <lhs>, <rhs>, { desc = <desc> })
    -- or a plugin like which-key.nvim

    vim.api.nvim_buf_set_keymap(buf, "n", "K",          "<Cmd>lua vim.lsp.buf.hover()<CR>",            { desc = "Hover Info" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>qf", "<Cmd>lua vim.diagnostic.setqflist()<CR>",     { desc = "Quickfix Diagnostics" })
    vim.api.nvim_buf_set_keymap(buf, "n", "[d",         "<Cmd>lua vim.diagnostic.goto_prev()<CR>",     { desc = "Previous Diagnostic" })
    vim.api.nvim_buf_set_keymap(buf, "n", "]d",         "<Cmd>lua vim.diagnostic.goto_next()<CR>",     { desc = "Next Diagnostic" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>e",  "<Cmd>lua vim.diagnostic.open_float()<CR>",    { desc = "Explain Symbol" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>",      { desc = "Code Action" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>cr", "<Cmd>lua vim.lsp.buf.rename()<CR>",           { desc = "Rename Symbol" })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<leader>fs", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",  { desc = "Document Symbol" })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<leader>fS", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { desc = "Workspace Symbol" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>gq", "<Cmd>lua vim.lsp.buf.formatting_sync()<CR>",  { desc = "Format File" })

    vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

-- Setup rust_analyzer via rust-tools.nvim
require("rust-tools").setup({
    server = {
        capabilities = capabilities,
        on_attach = lsp_attach,
    }
})

lspconfig.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
      },
    },
  }
}

lspconfig.bashls.setup {}
