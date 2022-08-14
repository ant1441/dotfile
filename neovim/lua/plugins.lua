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
    use 'EdenEast/nightfox.nvim'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lsp-config')
        end,
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
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup {}
        end
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- See builtins
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.completion.spell,
                },
            })
        end
    }

    -- Languages
    use 'simrat39/rust-tools.nvim'

    -- Snippets
    use {
        'SirVer/ultisnips',
        requires = {
            'honza/vim-snippets',
            rtp = '.'
        },
    }

    -- Editor
    -- highlight, navigate, and operate on sets of matching text.
    -- It extends vim's % key to language-specific words instead of just single characters.
    use 'andymass/vim-matchup'

    -- Highlight RGB, css colours
    use 'NvChad/nvim-colorizer.lua'

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

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {
            'nvim-lua/plenary.nvim',
        },
    }

    use 'stevearc/dressing.nvim'

    -- Scratch space
    -- Interesting stuff https://github.com/rockerBOO/awesome-neovim

    -- Nvim Treesitter configurations and abstraction layer
    -- Experimental, so not just yet
    -- nvim-treesitter/nvim-treesitter

    -- folke/trouble.nvim

    -- Simple winbar/statusline plugin that shows your current code context
    -- SmiteshP/nvim-navic

    -- Viewer & Finder for LSP symbols and tags
    -- liuchengxu/vista.vim

    -- A file explorer tree for neovim written in lua
    -- kyazdani42/nvim-tree.lua
    -- A tree explorer plugin for vim.
    -- preservim/nerdtree

    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
    -- williamboman/mason.nvim

    -- Closes brackets. Perfect companion to vim-endwise.
    -- Basically, a more conservative version of auto-pairs that only works when you press Enter.
    -- use '9mm/vim-closer'

    -- Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
    -- use 'dense-analysis/ale'

    -- A better user experience for viewing and interacting with Vim marks.
    -- I don't use marks often, maybe this would help?
    -- chentoast/marks.nvim
end)
