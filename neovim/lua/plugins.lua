-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Download / compile with :PackerSync
-- Setup with:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Colorschemes
    -- use 'Mofiqul/dracula.nvim'
    use "EdenEast/nightfox.nvim"

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lsp-config')
        end,
        -- requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'},

            -- Complete from LSP
            {'hrsh7th/cmp-nvim-lsp'},
            -- Complete from LSP with function signatures
            {'hrsh7th/cmp-nvim-lsp-signature-help'},

            -- Complete Snippets from UltiSnips
            {'quangnguyen30192/cmp-nvim-ultisnips'},
            -- Complete dictionary words
            {'uga-rosa/cmp-dictionary'},

            -- LSP icons in completion
            {'onsails/lspkind.nvim'}
         },
         config = function()
            require('cmp-config')
         end
    }
    -- use {
    --     'petertriho/cmp-git',
    --     requires = 'nvim-lua/plenary.nvim'
    -- }

    -- folke/trouble.nvim

    -- Languages
    use 'simrat39/rust-tools.nvim'

    -- Snippets
    use {
        'SirVer/ultisnips',
        requires = {{'honza/vim-snippets', rtp = '.'}},
        -- config = function()
        --     vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
        --     vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
        --     vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
        --     vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
        --     vim.g.UltiSnipsRemoveSelectModeMappings = 0
        -- end
    }

    -- Editor
    -- Closes brackets. Perfect companion to vim-endwise.
    -- Basically, a more conservative version of auto-pairs that only works when you press Enter.
    -- use '9mm/vim-closer'

    -- highlight, navigate, and operate on sets of matching text.
    -- It extends vim's % key to language-specific words instead of just single characters.
    use 'andymass/vim-matchup'

    -- Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
    -- use 'dense-analysis/ale'

    -- Git integration
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                current_line_blame = true,
            }
        end
    }

    use {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        -- Load statusline
        config = function()
            require('galaxyline-config')
        end,
        -- some icons
        requires = { 'kyazdani42/nvim-web-devicons' },
    }
end)
