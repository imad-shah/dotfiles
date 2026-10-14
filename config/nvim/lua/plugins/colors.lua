local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end
return {
    -- Rose Pine
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
    --     end
    -- },
    -- Dracula
    -- {
    --     "Mofiqul/dracula.nvim",
    --     config = function()
    --         vim.cmd.colorscheme("dracula")
    --     end
    -- },
    -- Onedark
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                -- style = "cool",
                style = "deep",
                -- transparent = transparent,
                -- lualine = { transparent = transparent },
                diagnostics = { darker = false },
                highlights = {
                    LspInlayHint = { fg = "$grey", fmt = "italic" },
                    Visual = { fg = "#dce4f2", bg = "#1d4f91" },
                },
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
            options = {
                theme = "auto",
            },
            sections = {
                lualine_c = {
                    { "filename", path = 2 }, -- 0 = just filename, 1 = relative path, 2 = absolute path
                },
            },
        },
    },
}
