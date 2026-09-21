vim.g.mapleader = ' '

-- <F5> runs the current file with whatever toolchain fits it.
-- (File-tree mappings live in lua/plugins/nvim-tree.lua, next to the plugin.)
local runners = {
    python = ':w<CR>:!python3 %<CR>',
    go = ':w<CR>:!go run %<CR>',
    lua = ':w<CR>:!lua %<CR>',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.tbl_keys(runners),
    callback = function(args)
        vim.keymap.set('n', '<F5>', runners[vim.bo[args.buf].filetype],
            { buffer = args.buf, noremap = true, silent = true })
    end,
})
