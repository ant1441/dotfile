return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            -- Bash
            "shfmt",
            "shellcheck",

            -- Lua
            "stylua",

            -- Python
            "ruff",

            "prettier",
            -- Optional: linters if you use them
            -- "pylint",
        },
        auto_install = true,
    },
}
