local custom_encoding = require("lualine.components.encoding"):extend()
local custom_fileformat = require("lualine.components.fileformat"):extend()

local navic = require("nvim-navic")

function custom_encoding:init(options)
	custom_encoding.super.init(self, options)
end

-- Only show encoding if it is not 'utf-8'
function custom_encoding:update_status(options)
	local result = custom_encoding.super.update_status(self, options)
	if result == "utf-8" then
		return
	else
		return result
	end
end

function custom_fileformat:init(options)
	custom_fileformat.super.init(self, options)
end

-- Only show fileformat if it is not '' (Unix)
function custom_fileformat:update_status(options)
	local result = custom_fileformat.super.update_status(self, options)
	if result == self.symbols["unix"] then
		return
	else
		return result
	end
end

require("lualine").setup({
	sections = {
		-- Other available sections:
		-- buffers, filesize, hostname, tabs, windows

		-- lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics", "lsp_status" },
		-- lualine_c = { "filename" },
		-- lualine_x = { "encoding", "fileformat", "filetype" },

		lualine_x = { custom_encoding, custom_fileformat, "filetype" },
		-- lualine_y = { "progress" },
		lualine_y = { "selectioncount", "searchcount", "progress" },
		-- lualine_z = { "location" },
	},
})
