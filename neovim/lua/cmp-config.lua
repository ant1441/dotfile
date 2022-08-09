-- Setup nvim-cmp.
local cmp = require('cmp')
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

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

