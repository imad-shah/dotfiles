vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Rounded borders for hover/signature popups. Replaces the old
-- vim.lsp.with(handlers.hover, {border=...}) pattern, deprecated in 0.11.
vim.opt.winborder = "rounded"

-- Default indent: 4 spaces. Go overrides this below (gofmt wants real tabs).
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
    end,
})
