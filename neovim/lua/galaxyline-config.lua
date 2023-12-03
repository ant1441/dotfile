-- From: https://github.com/LoydAndrew/nvim/blob/main/evilline.lua

local gl = require('galaxyline')
local gls = gl.section

-- source provider function
local fileinfo = require('galaxyline.provider_fileinfo')
local navic = require("nvim-navic")

-- built-in condition
local condition = require('galaxyline.condition')

-- nightfox spec
local spec = require("nightfox.spec").load(vim.g.colors_name)

local sides_bg = spec.bg2
local center_bg = spec.bg1
local no_color = '#ffffff'

local colors = {
    yellow   = '#fabd2f',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#afd700',
    orange   = '#FF8800',
    purple   = '#5d4d7a',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67'
}

local function file_readonly(readonly_icon)
  if vim.bo.filetype == 'help' then
    return ''
  end
  local icon = readonly_icon or ''
  if vim.bo.readonly == true then
    return " " .. icon .. " "
  end
  return ''
end

-- get current file name
local function get_current_file_name()
  -- local file = vim.fn.expand('%:t')
  local file = vim.fn.expand('%:f')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly(readonly_icon)) ~= 0 then
    return file .. file_readonly(readonly_icon)
  end
  local icon = modified_icon or ''
  if vim.bo.modifiable then
    if vim.bo.modified then
      return file .. ' ' .. icon .. '  '
    end
  end
  return file .. ' '
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

function has_file_type()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    return true
end

-- Providers
TrailingWhiteSpace = trailing_whitespace
GetCurrentFileName = get_current_file_name
GetLocationContext = function()
    return navic.get_location()
end
Space = function() return ' ' end

-- Conditions
HasFileType = has_file_type
IsNotUnix = function()
    if fileinfo.get_file_format() == "UNIX" then
        return false
    end
    return true
end
HideIfWidth = function(width)
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > width then
    return true
  end
  return false
end
ShowLocationContext = function()
    return navic.is_available() and HideIfWidth(40)
end

-- Layout

gls.left = {
    -- Spacer
    {
        FirstElement = {
            provider = Space,
            highlight = {no_color, sides_bg},
        },
    },
    -- Mode indicator
    {
        ViMode = {
            provider = function()
                -- See :help mode()
                -- Note: Only the first character is returned, which is all we need
                local alias = {
                    n     = 'NORMAL',
                    i     = 'INSERT',
                    v     ='VISUAL', [''] = 'VISUAL', V = 'VISUAL',
                    c     = 'COMMAND-LINE',
                    R     = 'REPLACE',

                    s     = 'SELECT', [''] = 'SELECT', S = 'SELECT',
                    r     = 'HIT-ENTER',
                    t     = 'TERMINAL',
                    ['!'] = 'SHELL',
                }
                local mode_color = {
                    -- Normal
                    n = colors.green,
                    -- Insert
                    i = colors.blue,
                    -- Visual (by character, blockwise, by line)
                    v = colors.magenta,
                    [''] = colors.magenta,
                    V = colors.magenta,
                    -- Command Line
                    c = colors.red,
                    -- Replace
                    R = colors.purple,

                    -- Select (by character, blockwise, by line)
                    s = colors.orange,
                    [''] = colors.orange,
                    S = colors.orange,
                    -- Hit-enter prompt
                    r = colors.cyan,
                    -- Shell or external command is executing
                    ['!']  = colors.green,
                    -- Terminal mode
                    t = colors.green,
                }
                local vim_mode = vim.fn.mode()
                vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode])
                return alias[vim_mode] .. '   '
            end,
            highlight = {no_color, sides_bg, 'bold'},
        },
    },
    -- Filetype icon
    {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, sides_bg},
        },
    },
    -- Filename
    {
        Filename = {
            provider = GetCurrentFileName,
            highlight = {spec.fg2, sides_bg, 'bold'}
        }
    },
    -- Filesize
    {
        Filesize = {
            provider = 'FileSize',
            condition = condition.hide_in_width,
            highlight = {spec.fg3, sides_bg, 'bold'}
        }
    },
    -- Git branch
    {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            icon = '  ',
            highlight = {spec.diag.hint, sides_bg, 'bold'},
        }
    },

    -- Spacer
    {
        Space = {
            provider = Space,
            condition = condition.hide_in_width,
            highlight = {no_color, sides_bg},
        }
    },

    -- Git diff - Add count
    {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.git.add, sides_bg},
        }
    },
    -- Git diff - Modified count
    {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.git.changed, sides_bg},
        }
    },
    -- Git diff - Remove count
    {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.git.removed, sides_bg},
        }
    },
    -- Angled Seperator
    {
        LeftEnd = {
            provider = function() return '' end,
            separator = '',
            separator_highlight = {center_bg, sides_bg},
            highlight = {sides_bg, sides_bg}
        }
    },

    -- Trailing whitespace marker
    {
        TrailingWhiteSpace = {
            provider = TrailingWhiteSpace,
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.diag.warn, center_bg},
        }
    },

    -- LSP Diagnostics info
    {
        DiagnosticError = {
            provider = 'DiagnosticError',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.diag.error, center_bg}
        }
    },
    {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            condition = condition.hide_in_width,
            icon = '  ',
            highlight = {spec.diag.warn, center_bg},
        }
    },
    -- Also DiagnosticHint & DiagnosticInfo

    -- Spacer
    {
        MiddleSpacer = {
            provider = Space,
            highlight = {no_color, center_bg}
        },
    },
}

gls.right = {
    {
        LocationContext = {
            provider = GetLocationContext,
            condition = ShowLocationContext,
            highlight = {spec.syntax.comment, center_bg},
        }
    },

    {
        LSPStatus = {
            provider = Space,
            condition = condition.check_active_lsp,
            highlight = {spec.diag.ok, center_bg},
            -- separator_highlight = {center_bg, center_bg},
            icon = '  ',
            separator = ' ',
        }
    },

    {
        RightStart = {
            provider = function() return '' end,
            separator_highlight = {center_bg, sides_bg},
            highlight = {center_bg, sides_bg}
        }
    },
    {
        FileFormat = {
            provider = 'FileFormat',
            condition = IsNotUnix,
            highlight = {spec.diag.error, sides_bg, 'bold'},
        }
    },
    {
        LineInfo = {
            provider = {Space, 'LineColumn'},
            highlight = {no_color, sides_bg},
        },
    },
    {
        PerCent = {
            provider = 'LinePercent',
            separator = ' ',
            separator_highlight = {sides_bg, sides_bg},
            highlight = {spec.diag.info, sides_bg, 'bold'},
        }
    },

    {
        ScrollBar = {
            provider = 'ScrollBar',
            highlight = {spec.diag.info, sides_bg},
        }
    },
}

-- Short line layout
-- TODO: Doesn't work?

gls.short_line_left = {
    {
        BufferType = {
            provider =  'FileTypeName',
            separator = '',
            condition = HasFileType,
            -- separator_highlight = {no_color, center_bg},
            highlight = {sides_bg, no_color}
        }
    }
}

gls.short_line_right = {
    {
        BufferIcon = {
            provider= 'BufferIcon',
            separator = '',
            condition = HasFileType,
            -- separator_highlight = {no_color, center_bg},
            highlight = {sides_bg, no_color}
        }
    }
}

-- Scratch space

-- gl.short_line_list = {
--     'LuaTree',
--     'NvimTree',
--     'vista',
--     'dbui',
--     'startify',
--     'term',
--     'nerdtree',
--     'fugitive',
--     'fugitiveblame',
--     'plug',
--     'plugins'
-- }

-- local ProgFileTypes = {
--     'lua',
--     'python',
--     'typescript',
--     'typescriptreact',
--     'react',
--     'javascript',
--     'javascriptreact',
--     'rust',
--     'go',
--     'html'
-- }

-- for checking value in table
-- local function has_value (tab, val)
--     for index, value in ipairs(tab) do
--         if value == val then
--             return true
--         end
--     end
--
--     return false
-- end

-- current_func_status with treesitter
-- local function get_current_func_from_treesitter()
--   local opts = {
--     indicator_size = 100,
--     type_patterns = {'class', 'function', 'method', },
--     transform_fn = function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
--     separator = '  ',
--   }
--   local status = vim.fn['nvim_treesitter#statusline'](opts)
--   if not status or status == '' then
--       return ''
--   end
--       return status
--   end

-- TreesitterContext = get_current_func_from_treesitter

-- function has_file_prog_filetype()
--     local f_type = vim.bo.filetype
--     if not f_type or f_type == '' then
--         return false
--     end
--     if has_value(ProgFileTypes, f_type) then
--         return true
--     end
--     return false
-- end

-- Scratch Segments:

-- Left

    -- {
    --   TreesitterContext = {
    --     provider = TreesitterContext,
    --     condition = has_file_prog_filetype,
    --     icon = '  λ ',
    --     highlight = {colors.yellow, center_bg},
    --   }
    -- },
