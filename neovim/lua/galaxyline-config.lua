-- From: https://github.com/LoydAndrew/nvim/blob/main/evilline.lua

local gl = require('galaxyline')
local gls = gl.section

-- source provider function
local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
-- local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')
local whitespace = require('galaxyline.provider_whitespace')
local lspclient = require('galaxyline.provider_lsp')

-- built-in condition
local condition = require('galaxyline.condition')

-- local gps = require('nvim-gps')
-- local dap = require('dap')
-- VistaPlugin = extension.vista_nearest

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

local colors = {
    bg = "#282c34",
    line_bg = "#353644",
    fg = '#8FBCBB',
    fg_green = '#65a380',

    yellow = '#fabd2f',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#afd700',
    orange = '#FF8800',
    purple = '#5d4d7a',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67'
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


local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end


local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  return lsp_status(status)
end



-- local function get_debug_status()
--   local status = dap.status()
--   if not status or status == '' then
--       return ''
--   end
--   return  '  ' .. status
-- end

function get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
    end
  return ''
end

local function get_current_func()
  local has_func, func_name = pcall(vim.api.nvim_buf_get_var, 0, 'coc_current_function')
  if not has_func then return end
      return func_name
  end

function get_function_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_current_func()
    end
  return ''
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

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

-- local function get_current_context()
--   if vim.fn.exists('nvim_treesitter#statusline') == 1 then
--     return get_current_func_from_treesitter()
--     end
--   return ''
-- end

CocStatus = get_diagnostic_info
-- DebugInfo = get_debug_status
CocFunc = get_current_func
-- TreesitterContext = get_current_func_from_treesitter
TrailingWhiteSpace = trailing_whitespace

function has_file_type()
    local f_type = vim.bo.filetype
    if not f_type or f_type == '' then
        return false
    end
    return true
end

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

-- Layout

gls.left = {
    -- Spacer
    {
        FirstElement = {
            provider = function() return ' ' end,
            highlight = {colors.blue, colors.line_bg}
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
                    v = colors.magenta, [''] = colors.magenta, V = colors.magenta,
                    -- Command Line
                    c = colors.red,
                    -- Replace
                    R = colors.purple,

                    -- Select (by character, blockwise, by line)
                    s = colors.orange, [''] = colors.orange, S = colors.orange,
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
            highlight = {colors.red, colors.line_bg, 'bold'},
        },
    },
    -- Filetype icon
    {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = {fileinfo.get_file_icon_color, colors.line_bg},
        },
    },
    -- Filesize
    {
        FileName = {
            provider = {get_current_file_name, 'FileSize'},
            condition = condition.buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, 'bold'}
        }
    },
    -- Git marker
    {
        GitIcon = {
            provider = function() return '  ' end,
            condition = condition.check_git_workspace,
            highlight = {colors.yellow, colors.line_bg},
        }
    },
    -- Git branch
    {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            highlight = {colors.yellow, colors.line_bg, 'bold'},
        }
    },

    -- Spacer
    {
        Space = {
            provider = function () return '' end
        }
    },

    -- Git diff - Add count
    {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width,
            icon = '   ',
            highlight = {colors.green, colors.line_bg},
        }
    },
    -- Git diff - Modified count
    {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width,
            icon = '   ',
            highlight = {colors.orange, colors.line_bg},
        }
    },
    -- Git diff - Remove count
    {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width,
            icon = '   ',
            highlight = {colors.red, colors.line_bg},
        }
    },
    -- Angled Seperator (broken on Ganymede?)
    {
        LeftEnd = {
            provider = function() return '' end,
            separator = '',
            separator_highlight = {colors.bg, colors.line_bg},
            highlight = {colors.line_bg, colors.line_bg}
        }
    },

    -- Trailing whitespace marker
    {
        TrailingWhiteSpace = {
            provider = TrailingWhiteSpace,
            icon = '   ',
            highlight = {colors.yellow, colors.bg},
        }
    },

    -- {
    --     DiagnosticError = {
    --         provider = 'DiagnosticError',
    --         icon = '  ',
    --         highlight = {colors.red, colors.bg}
    --     }
    -- },
    -- -- Spacer
    -- {
    --     Space = {
    --         provider = function () return '' end
    --     }
    -- },
    -- {
    --     DiagnosticWarn = {
    --         provider = 'DiagnosticWarn',
    --         icon = '   ',
    --         highlight = {colors.yellow, colors.bg},
    --     }
    -- },

    -- {
    --     CocStatus = {
    --         provider = CocStatus,
    --         highlight = {colors.green, colors.bg},
    --         icon = '   '
    --     }
    -- },


    -- {
    --   CocFunc = {
    --     provider = CocFunc,
    --     icon = ' ',
    --     highlight = {colors.yellow, colors.bg},
    --   }
    -- },

    -- {
    --   TreesitterContext = {
    --     provider = TreesitterContext,
    --     condition = has_file_prog_filetype,
    --     icon = '  λ ',
    --     highlight = {colors.yellow, colors.bg},
    --   }
    -- },

    -- {
    -- nvimGPS = {
    --         provider = function()
    --             return gps.get_location()
    --         end,
    --         condition = function()
    --             return gps.is_available()
    --         end,
    --         icon = '  ',
    --         highlight = {colors.yellow, colors.bg},
    --     }
    -- }
}

gls.right = {
    {
        FileFormat = {
            provider = 'FileFormat',
            separator = ' ',
            separator_highlight = {colors.bg, colors.line_bg},
            highlight = {colors.fg, colors.line_bg, 'bold'},
        }
    },
    -- {
    --   Debug = {
    --     provider = DebugInfo,
    --     separator = ' ',
    --     separator_highlight = {colors.blue, colors.line_bg},
    --     separator_highlight = {colors.bg, colors.line_bg},
    --     highlight = {colors.red, colors.line_bg, 'bold'},
    --   }
    -- },
    {
        LineInfo = {
            provider = 'LineColumn',
            separator = ' | ',
            separator_highlight = {colors.blue, colors.line_bg},
            highlight = {colors.fg, colors.line_bg},
        },
    },
    {
        PerCent = {
            provider = 'LinePercent',
            separator = ' ',
            separator_highlight = {colors.line_bg, colors.line_bg},
            highlight = {colors.cyan, colors.darkblue, 'bold'},
        }
    },

    {
        ScrollBar = {
            provider = 'ScrollBar',
            highlight = {colors.blue, colors.purple},
        }
    },

    -- {
    --   Vista = {
    --     provider = VistaPlugin,
    --     separator = ' ',
    --     separator_highlight = {colors.bg, colors.line_bg},
    --     highlight = {colors.fg, colors.line_bg, 'bold'},
    --   }
    -- }
    -- {
    --     Time = {
    --         provider = function()
    --             return '  ' .. os.date('%H:%M') .. ' '
    --         end,
    --         highlight = {colors.green, colors.gray},
    --         separator = ' ',
    --     }
    -- },
}

-- Short line layout

gls.short_line_left[1] = {
  BufferType = {
    provider =  'FileTypeName',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.fg, colors.purple}
  }
}


gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    separator = '',
    condition = has_file_type,
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.fg, colors.purple}
  }
}
