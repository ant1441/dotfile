return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
        current_line_blame = true,
        preview_config = {
            border = "rounded",
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            -- 1. Register the group name FIRST
            -- We use pcall to avoid crashing if which-key isn't loaded yet
            local ok, wk = pcall(require, "which-key")
            if ok then
                wk.add({
                    { "<leader>h", group = "Git Hunk", buffer = bufnr },
                })
            else
                -- Notify the user if which-key is missing (rare, but possible)
                vim.notify(
                    "which-key not found: <leader>h group name won't be shown.",
                    vim.log.levels.WARN,
                    { title = "Gitsigns Config" }
                )
            end

            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, "Next hunk")
            map("n", "[h", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, "Prev hunk")

            -- Actions
            map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
            map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage hunk (visual)")
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset hunk (visual)")
            map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
            map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
            map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

            -- Preview & blame
            map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, "Blame line")
            map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
            map("n", "<leader>hd", gs.diffthis, "Diff this")
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, "Diff this ~")

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
        end,
    },
}
