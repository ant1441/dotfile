local cmp_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")

-- Ensure these Language servers are always installed
local ensure_installed_lsp = {
	"bashls",
	"jedi_language_server",
	"lua_ls",
	"rust_analyzer",

	-- TODO: Can Mason prompt for language servers when opening new file?
}

local ensure_installed_formatters = {
	"isort",
	"ruff",
	"prettier",
}

local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

require("mason").setup()
require("mason-lspconfig").setup({
	-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
	ensure_installed = ensure_installed_lsp,
	handlers = {
		-- Automatically setup language servers
		function(server_name) -- default handler
			lspconfig[server_name].setup({
				capabilities = capabilities,
			})
		end,
		["lua_ls"] = function()
			-- Get NVIM lua setup - from lsp-zero
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						-- Disable telemetry
						telemetry = { enable = false },
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
							path = runtime_path,
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim", "builtin" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								-- Make the server aware of Neovim runtime files
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
					},
				},
			})
		end,
	},
})

require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		local lsp_format_opt
		if disable_filetypes[vim.bo[bufnr].filetype] then
			lsp_format_opt = "never"
		else
			lsp_format_opt = "fallback"
		end
		return {
			timeout_ms = 500,
			lsp_format = lsp_format_opt,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "ruff" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

require("mason-conform").setup({
	ensure_installed = ensure_installed_formatters,
	automatic_installation = false,
})
