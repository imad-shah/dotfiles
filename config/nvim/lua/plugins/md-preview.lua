return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && ./install.sh",
    ft = { "markdown" },
    init = function()
        -- WSL's xdg-open can't reach a Windows browser; hand the URL to Windows.
        if vim.fn.has("wsl") == 1 then
            vim.cmd([[
                function! MkdpOpenInWindows(url)
                    call jobstart(['explorer.exe', a:url])
                endfunction
            ]])
            vim.g.mkdp_browserfunc = "MkdpOpenInWindows"
        end
    end,
    keys = {
        { "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Toggle markdown preview" },
    },
}
