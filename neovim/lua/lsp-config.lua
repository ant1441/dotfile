local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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

-- Language specific setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Ansible [ansible-language-server]
-- lspconfig.ansiblels.setup {}

-- Bash [bash-language-server]
lspconfig.bashls.setup {
    capabilities = capabilities,
    on_attach = lsp_attach,
}

-- CSS [vscode-langservers-extracted]
-- Note: Extra snippet config required
-- lspconfig.cssls.setup {}

-- Docker [dockerfile-language-server-nodejs]
-- lspconfig.dockerls.setup{}

-- Javascript [vscode-eslint-language-server]
-- lspconfig.eslintls.setup{}

-- Go
-- lspconfig.gopls.setup{}

-- HTML [vscode-langservers-extracted]
-- Note: Extra snippet config required
-- lspconfig.htmlls.setup{}

-- Java
-- JSON
-- Terraform

-- YAML [yaml-language-server]
lspconfig.yamlls.setup {
    capabilities = capabilities,
    on_attach = lsp_attach,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
            },
        },
    }
}

-- Vim [vim-language-server]
lspconfig.vimls.setup {
    capabilities = capabilities,
    on_attach = lsp_attach,
}
