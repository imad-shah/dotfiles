return {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = { "markdown" },
    keys = {
        { "<leader>md", "<cmd>MarkdownPreview<CR>", ft = "markdown", desc = "Markdown preview" },
    },
}
