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
                "rust",
                "ssh_config",
                "terraform",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            }

            local group = vim.api.nvim_create_augroup("ThePrimeagenTreesitter", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
                group = group,
                callback = function()
                    if vim.bo.buftype ~= "" then
                        return
                    end

                    local ok, err = pcall(vim.treesitter.start, 0)
                    if ok then

                        -- Folds
                        -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                        -- vim.wo[0][0].foldmethod = 'expr'

                        -- Indentation (experimental)
                        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                        return
                    end

                    local message = tostring(err)

                    if message:match("language could not be determined")
                        then
                        return
                    end

                    if message:match("Parser could not be created")
                        or message:match("No parser for language")
                        then
                            local b = buf or 0
                            vim.notify(
                                ("No Tree-sitter parser for %s"):format(
                                    vim.bo[b].filetype ~= "" and vim.bo[b].filetype or (lang or "unknown")
                                ),
                                vim.log.levels.WARN
                            )
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
