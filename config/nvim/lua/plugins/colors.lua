local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end
return {
    -- {
    --     "rose-pine/neovim",
    --     name = "rose-pine",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         variant = "moon", -- options: auto, main, moon, dawn
    --         -- dark_variant = "main",  -- options: main, moon, dawn
    --         -- styles = {
    --         --     transparency = true,
    --         -- },
    --     },
    --     config = function()
    --         require("rose-pine").setup({
    --             variant = "moon",
    --         })
    --         vim.cmd.colorscheme("rose-pine")
    --         enable_transparency()
    --     end
    -- },
    -- Flow
    -- {
    --     "0xstepit/flow.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     tag = "v2.0.1",
    --     opts = {
    --         theme = {
    --             style = "dark",
    --             transparent = true,
    --         },
    --         colors = {
    --             fluo = "pink",
    --         }
    --     },
    --     config = function()
    --         require("flow").setup({})
    --         vim.cmd.colorscheme("flow")
    --         -- enable_transparency()
    --     end
    -- },
    -- Dracula
    -- {
    --     "Mofiqul/dracula.nvim",
    --     config = function()
    --         vim.cmd.colorscheme("dracula")
    --         -- enable_transparency()
    --     end
    -- },
    -- Onedark
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "deep",
            })
            require("onedark").load()
            enable_transparency()
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            theme = "auto",
        },
    },
}
