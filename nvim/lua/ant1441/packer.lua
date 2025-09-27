-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
	})

	use({
		"folke/which-key.nvim",
	})

	-- Colourscheme
	use({
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({
				options = {
					-- Ensure a properly black background, matching tmux
					transparent = false,
					dim_inactive = true,
				},
			})
		end,
	})
	use("nvim-tree/nvim-web-devicons")

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup()
		end,
	})

	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})

	-- TODO: stevearc/dressing.nvim?
	--       Or folke/snacks.nvim

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	-- "SmiteshP/nvim-navic",

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use({
		"stevearc/conform.nvim",
		requires = {
			"LittleEndianRoot/mason-conform",
		},
	})

	-- Autodetect tabstop, etc.
	use("tpope/vim-sleuth")

	-- Notifications
	use({
		"rcarriga/nvim-notify",
		requires = {
			-- TODO: Is this too big? 'j-hui/fidget.nvim' could be an alternative?
			"mrded/nvim-lsp-notify",
		},
		config = function()
			vim.notify = require("notify")
			require("lsp-notify").setup({})
		end,
	})

	use({
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("barbar").setup({
				animation = false,
				auto_hide = true,
				icons = {
					diagnostics = {
						-- NOTE: This might be a bit noisy?
						[vim.diagnostic.severity.ERROR] = { enabled = true },
						[vim.diagnostic.severity.WARN] = { enabled = true },
						[vim.diagnostic.severity.INFO] = { enabled = true },
						[vim.diagnostic.severity.HINT] = { enabled = true },
					},
					gitsigns = {
						added = { enabled = true, icon = "+" },
						changed = { enabled = true, icon = "~" },
						deleted = { enabled = true, icon = "-" },
					},
					pinned = { button = "", filename = true },
					preset = "slanted",
				},
			})
		end,
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Completion
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			-- TODO: Evaluate:
			-- 'hrsh7th/cmp-emoji'
			-- 'hrsh7th/cmp-nvim-lsp-signature-help'?
			-- 'hrsh7th/cmp-nvim-lsp-document-symbol'
			"hrsh7th/nvim-cmp",

			"onsails/lspkind.nvim",

			-- Snippet
			-- TODO: Evaluate best snippet thing
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",

			-- TODO:
			-- kosayoda/nvim-lightbulb
		},
	})

	-- Other
	-- laytan/cloak.nvim - Hide secrets, useful for AWS credentials?
	-- folke/trouble.nvim - Markdown preview
	-- tpope/vim-fugitive - Git stuff
	-- folke/zen-mode.nvim
	--   https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/lazy/zenmode.lua
	-- aserowy/tmux.nvim
end)
