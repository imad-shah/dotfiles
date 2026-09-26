return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            view = {
                relativenumber = true,
                width = 30,
            },
            filters = {
                dotfiles = false,
            },
        })

        -- auto-close nvim when the tree is the last window
        vim.api.nvim_create_autocmd("QuitPre", {
            callback = function()
                local tree_wins = {}
                local floating_wins = {}
                local wins = vim.api.nvim_list_wins()
                for _, w in ipairs(wins) do
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                    if bufname:match("NvimTree_") ~= nil then
                        table.insert(tree_wins, w)
                    end
                    if vim.api.nvim_win_get_config(w).relative ~= "" then
                        table.insert(floating_wins, w)
                    end
                end
                if #wins - #floating_wins - #tree_wins == 1 then
                    for _, w in ipairs(tree_wins) do
                        vim.api.nvim_win_close(w, true)
                    end
                end
            end,
        })

        vim.keymap.set("n", "<leader>cd", ":NvimTreeFindFile<CR>", { silent = true })
        vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>", { silent = true })
    end,
}
