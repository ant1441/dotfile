-- Setup nvim-cmp.
local cmp = require('cmp')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[LSP*]",
                ultisnips = "[UltiSnips]",
                cmdline = "[Cmd]",
                dictionary = "[Dict]",
            })
        })
    },
    mapping = cmp.mapping.preset.insert({
        -- Scroll contents of window
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        -- Start completion, eg. if you dismissed it
        ['<C-Space>'] = cmp.mapping.complete(),
        -- Cancel completion
        ['<C-e>'] = cmp.mapping.abort(),
        -- Accept currently selected item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        -- Go to next selection
        -- BUG: Tab sometimes accepts an item? UltiSnips issue?
        ["<Tab>"] = cmp.mapping(
        function(fallback)
            -- cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            -- Don't expand on <Tab>
            cmp_ultisnips_mappings.compose { "jump_forwards", "select_next_item" }(fallback)
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
        -- Go to previous selection
        ["<S-Tab>"] = cmp.mapping(
        function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
        ),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
    }, {
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
    }, {
        { name = 'dictionary' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources(
    --{
    --    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    --},
    {
        { name = 'buffer' },
    })
})

-- Setup lspconfig.

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
    -- <lhs>        <rhs>                        <desc>
    -- "K"          vim.lsp.buf.hover            "Hover Info"
    -- "<leader>qf" vim.diagnostic.setqflist     "Quickfix Diagnostics"
    -- "[d"         vim.diagnostic.goto_prev     "Previous Diagnostic"
    -- "]d"         vim.diagnostic.goto_next     "Next Diagnostic"
    -- "<leader>e"  vim.diagnostic.open_float    "Explain Diagnostic"
    -- "<leader>ca" vim.lsp.buf.code_action      "Code Action"
    -- "<leader>cr" vim.lsp.buf.rename           "Rename Symbol"
    -- "<leader>fs" vim.lsp.buf.document_symbol  "Document Symbols"
    -- "<leader>fS" vim.lsp.buf.workspace_symbol "Workspace Symbols"
    -- "<leader>gq" vim.lsp.buf.formatting_sync  "Format File"

    vim.api.nvim_buf_set_keymap(buf, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover Info" })
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)

    vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

-- Setup rust_analyzer via rust-tools.nvim
require("rust-tools").setup({
    server = {
        capabilities = capabilities,
        on_attach = lsp_attach,
    }
})
