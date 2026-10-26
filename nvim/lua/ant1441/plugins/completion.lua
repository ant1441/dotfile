return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
        "Kaiser-Yang/blink-cmp-dictionary",
        "Kaiser-Yang/blink-cmp-git",

        -- "onsails/lspkind.nvim",

        -- 'rafamadriz/friendly-snippets'
        -- xzbdmw/colorful-menu.nvim
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "default" },

        completion = {
            menu = {
                border = "rounded",
                draw = {
                    columns = { { "kind_icon", gap = 1, "source_name" }, { "label", "label_description", gap = 1 } },
                },
            },
            documentation = {
                auto_show = false,
                window = {
                    border = "rounded",
                },
            },
            ghost_text = {
                enabled = true,
            },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "git", "dictionary" },
            providers = {
                dictionary = {
                    module = "blink-cmp-dictionary",
                    name = "Dict",
                    min_keyword_length = 1,
                    opts = {
                        -- Optional: explicitly force fallback mode
                        -- (By default, fallback is used when fzf is not found)
                        force_fallback = true,
                        dictionary_files = function()
                            local filename = vim.api.nvim_buf_get_name(0)
                            local irish_dir = vim.fn.expand("~/Documents/Irish/")
                            local irish_dict = vim.fn.expand("~/Documents/Irish/ga-words.txt")
                            local british_dict = "/usr/share/dict/british-english"

                            if filename:sub(1, #irish_dir) == irish_dir and vim.fn.filereadable(irish_dict) == 1 then
                                return { irish_dir .. "ga-words.txt" }
                            end
                            if filename:match("%.ga%.md$") and vim.fn.filereadable(irish_dict) == 1 then
                                return { irish_dir .. "ga-words.txt" }
                            end

                            return { british_dict }
                        end,
                        dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") },
                    },
                },
                git = {
                    module = "blink-cmp-git",
                    name = "Git",
                    -- only enable this source when filetype is gitcommit, markdown, or 'octo'
                    enabled = function()
                        return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
                    end,
                    --- @module 'blink-cmp-git'
                    --- @type blink-cmp-git.Options
                    opts = {
                        -- options for the blink-cmp-git
                    },
                },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Experimental signature help support
        signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
}
