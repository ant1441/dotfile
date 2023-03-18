local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local navic = require("nvim-navic")

-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Configure diagnostic display
vim.diagnostic.config({
    virtual_text = {
        -- Prepend with diagnostic source
        source = true,
    },
    float = {
        severity_sort = true,
        source = true,
        border = "rounded",
    }
})

-- Examples at https://gist.github.com/equalis3r/ca1fe0266b18be5893b2d9605b492a3b
local lsp_attach = function(client, buf)
    navic.attach(client, buf)

    -- LSP actions
    -- Could use which-key.nvim?

    -- Pres 'K' twice to jump into the Hover window
    vim.api.nvim_buf_set_keymap(buf, "n", "K",          "<Cmd>lua vim.notify('test', 'error')<CR>",            { desc = "Hover Info" })
    --vim.api.nvim_buf_set_keymap(buf, "n", "K",          "<Cmd>lua vim.lsp.buf.hover()<CR>",            { desc = "Hover Info" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<a-cr>",     "<Cmd>lua vim.lsp.buf.code_action()<CR>",      { desc = "Code Action" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>cr", "<Cmd>lua vim.lsp.buf.rename()<CR>",           { desc = "Rename Symbol" })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<leader>fs", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",  { desc = "Document Symbol" })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<leader>fS", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { desc = "Workspace Symbol" })
    -- Format the file (unsure the difference between formatting_sync & formatting (& just format, does that work?)
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>gq", "<Cmd>lua vim.lsp.buf.formatting_sync()<CR>",  { desc = "Format File" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>F",  "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>",       { desc = "Format File" })

    vim.api.nvim_buf_set_keymap(buf, "n", "gd", "<Cmd>Telescope lsp_definitions<CR>",  { desc = "Go to Definition" })
    vim.api.nvim_buf_set_keymap(buf, "n", "gr", "<Cmd>Telescope lsp_references<CR>",  { desc = "Find References" })
    vim.api.nvim_buf_set_keymap(buf, "n", "gi", "<Cmd>Telescope lsp_implementations<CR>",  { desc = "Find Implementations" })
    vim.api.nvim_buf_set_keymap(buf, "n", "gt", "<Cmd>Telescope lsp_type_definitions<CR>",  { desc = "Go to TypeDefinition" })
    vim.api.nvim_buf_set_keymap(buf, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to Declaration" })

    vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.api.nvim_buf_set_option(buf, "omnifunc",   "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(buf, "tagfunc",    "v:lua.vim.lsp.tagfunc")

    -- Diagnostic actions
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>qf", "<Cmd>lua vim.diagnostic.setqflist()<CR>",     { desc = "Quickfix Diagnostics" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>",     { desc = "Next Diagnostic" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>dp", "<Cmd>lua vim.diagnostic.goto_prev()<CR>",     { desc = "Previous Diagnostic" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>dk", "<Cmd>lua vim.diagnostic.open_float()<CR>",    { desc = "Explain Symbol" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<leader>e", "<Cmd>lua vim.diagnostic.open_float()<CR>",     { desc = "Explain Symbol" })
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
    tools = {
        inlay_hints = {
        }
    },
    server = {
        capabilities = capabilities,
        on_attach = lsp_attach,
        settings = {
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        },
    }
})

-- Language specific setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

function lspconfig_setup(args)
    setmetatable(args, {__index={executable=nil, opts={}}})
    local lsp, executable, opts =
        args[1] or args.lsp,
        args[2] or args.executable,
        args[3] or args.opts

    if executable ~= nil and vim.fn.executable(executable) == 0 then
        vim.notify(string.format("%s not installed", executable), "warn")
        return
    end

    final_opts = {
        capabilities = capabilities,
        on_attach = lsp_attach,
    }
    for key, value in pairs(opts) do
        final_opts[key] = value
    end

    lsp.setup(final_opts)
end

-- Arduino [arduino-language-server]
lspconfig_setup {lspconfig.arduino_language_server, 'arduino-language-server'}

-- Ansible [ansible-language-server]
-- lspconfig.ansiblels.setup {}

-- Bash [bash-language-server]
lspconfig_setup {lspconfig.bashls, 'bash-language-server'}

-- C / C++ [ccls]
-- TODO: We don't have capabilities / on_attach here?
lspconfig.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = { "-frounding-math"} ;
    };
  }
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

-- Python [jedi-language-server]
lspconfig_setup {lspconfig.jedi_language_server, 'jedi-language-server'}

-- Terraform

-- Typescript [typescript-language-server]
lspconfig_setup {lspconfig.tsserver, 'typescript-language-server'}

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
lspconfig_setup {lspconfig.vimls, 'vim-language-server'}
