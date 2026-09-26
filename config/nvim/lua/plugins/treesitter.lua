return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                -- the three languages you actually edit
                "python",
                "go",
                "lua",
                -- their companions
                "gomod",
                "gosum",
                "luadoc",
                -- config / docs files you open alongside them
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
