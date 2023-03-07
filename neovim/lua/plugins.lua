-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Download / compile with :PackerSync
-- Setup with:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

if vim.fn.has('nvim-0.8') == 0 then
    vim.notify("Requires neovim 0.8+", vim.log.levels.ERROR)
end

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Testing terraform
    use 'hashivim/vim-terraform'

    -- Colorschemes
    -- use 'Mofiqul/dracula.nvim'
    use 'EdenEast/nightfox.nvim'

    -- Filetab plugin
    use {
        'romgrk/barbar.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function()
            require('bufferline').setup {
                animation = false,
                auto_hide = true,
                icon_custom_colors = true,
                icon_pinned = '車',
            }
        end,
    }

    -- Better notifications, see :Telescope notify and :Notifications
    use {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
            require("notify").setup { stages = 'fade_in_slide_out', background_colour = 'FloatShadow', timeout = 3000, }

            -- Send a notification to test
            vim.notify("nvim-nofity installed", "debug", {
                title = "Neovim config",
            })
        end,
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lsp-config')
        end,
    }
    -- Copletions
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
            {'hrsh7th/cmp-nvim-lsp-document-symbol'},

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
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup {}
        end
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- See builtins
                    -- These git actions don't seem to work?
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.gitrebase,

                    null_ls.builtins.code_actions.gomodifytags,

                    -- Spell suggestions completion source.
                    -- Might be a bit noisy?
                    -- null_ls.builtins.completion.spell,

                    -- Tags completion source.
                    null_ls.builtins.completion.tags,

                    -- Catch insensitive, inconsiderate writing.
                    -- Could be useful?
                    -- null_ls.builtins.diagnostics.alex,

                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.diagnostics.todo_comments,

                    -- Sources to try out:
                    -- null_ls.builtins.diagnostics.ansiblelint,
                    -- null_ls.builtins.diagnostics.cfn_lint,
                    -- null_ls.builtins.diagnostics.checkmake,
                    -- null_ls.builtins.diagnostics.commitlint,
                    -- null_ls.builtins.diagnostics.gitlint,
                    -- null_ls.builtins.diagnostics.semgrep,
                    -- null_ls.builtins.diagnostics.terraform_validate,
                    -- null_ls.builtins.diagnostics.tfsec,
                    -- null_ls.builtins.formatting.beautysh

                    null_ls.builtins.code_actions.shellcheck,
                },
            })
        end,
        requires = {
            'nvim-lua/plenary.nvim',
        },
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Languages
    use 'simrat39/rust-tools.nvim'

    use {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup(
            {
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    }

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
    use {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }

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
        requires = {
            -- some icons
            'kyazdani42/nvim-web-devicons',
            'SmiteshP/nvim-navic'
        },
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {
            'nvim-lua/plenary.nvim',
        },
    }

    use {
        "AckslD/nvim-neoclip.lua",
        requires = {
            {'nvim-telescope/telescope.nvim'},
        },
        config = function()
            require('neoclip').setup()
        end,
    }

    use {
        'ANGkeith/telescope-terraform-doc.nvim',
        requires = {
            {'nvim-telescope/telescope.nvim'},
        },
        config = function()
            require('telescope').load_extension('terraform_doc')
        end,
    }

    use 'stevearc/dressing.nvim'

    use {
        "ellisonleao/glow.nvim",
        config = function()
            require("glow").setup()
        end,
    }

    -- Scratch space
    -- Interesting stuff https://github.com/rockerBOO/awesome-neovim

    -- Nvim Treesitter configurations and abstraction layer
    -- Experimental, so not just yet
    -- nvim-treesitter/nvim-treesitter

    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    -- folke/trouble.nvim

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

    -- Generate git links - like :GBrowse
    -- ruifm/gitlinker.nvim

    --  Vim script for text filtering and alignment
    -- use 'godlygeek/tabular'

    -- A comment toggler for Neovim, written in Lua
    -- use 'terrortylor/nvim-comment'
end)
