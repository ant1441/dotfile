return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        init = function()
            local parsers = {
                "asm",
                "bash",
                "c",
                "css",
                "csv",
                "diff",
                "dockerfile",
                "gitcommit",
                "git_config",
                "gitignore",
                "git_rebase",
                "go",
                "html",
                "java",
                "javascript",
                "jinja",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "rust",
                "ssh_config",
                "terraform",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            }

            local group = vim.api.nvim_create_augroup("ant1441-treesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                callback = function(args)
                    if vim.bo[args.buf].buftype ~= "" then
                        return
                    end

                    local ok, err = pcall(vim.treesitter.start, args.buf)
                    if ok then
                        -- Folds
                        -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                        -- vim.wo[0][0].foldmethod = 'expr'

                        -- Indentation (experimental)
                        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                        return
                    end

                    local message = tostring(err)

                    if message:match("language could not be determined") then
                        return
                    end

                    if message:match("Parser could not be created") or message:match("No parser for language") then
                        vim.notify(("No Tree-sitter parser for %s"):format(args.match), vim.log.levels.WARN)
                        return
                    end

                    -- Don't hide unrelated Tree-sitter errors.
                    error(err)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                group = group,
                pattern = "VeryLazy",
                once = true,
                callback = function()
                    require("nvim-treesitter").install(parsers)
                end,
            })
        end,
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    --     lazy = false,
    --     config = function()
    --         require("nvim-treesitter-textobjects").setup({
    --             select = {
    --                 enable = true,
    --                 lookahead = true,
    --                 keymaps = {
    --                     ["af"] = "@function.outer",
    --                     ["if"] = "@function.inner",
    --                 },
    --             },
    --         })
    --     end,
    -- },
}
