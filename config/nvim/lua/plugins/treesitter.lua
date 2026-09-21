return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "python",
                "go",
                "lua",

                "gomod",
                "gosum",
                "luadoc",

                "bash",
                "json",
                "yaml",
                "toml",
                "markdown",
                "markdown_inline",
                "diff",
                "vim",
                "vimdoc",
                "query",
            },
            auto_install = true,
        })
    end
}
