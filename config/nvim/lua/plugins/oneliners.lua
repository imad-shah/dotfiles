return {
    { -- Show CSS Colors
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup({})
        end
    },

    { -- Auto pairs
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({})
        end
    },
}
