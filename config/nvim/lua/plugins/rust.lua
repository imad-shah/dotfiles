-- Every rustc/clippy diagnostic in the workspace, rendered in full as
-- `cargo build` prints it, in one bottom split. rust-analyzer only attaches
-- the rendered text to cargo-check diagnostics, so its own native ones are
-- left out (same as `RustLsp renderDiagnostic`).
local all_diagnostics_buf
local function show_all_diagnostics()
    local diagnostics = vim.iter(vim.diagnostic.get())
        :filter(function(d) return vim.tbl_get(d, 'user_data', 'lsp', 'data', 'rendered') ~= nil end)
        :totable()
    if #diagnostics == 0 then
        vim.notify('No rendered Rust diagnostics.', vim.log.levels.INFO)
        return
    end
    -- Errors first, then by file and position.
    table.sort(diagnostics, function(a, b)
        if a.severity ~= b.severity then return a.severity < b.severity end
        local a_file, b_file = vim.api.nvim_buf_get_name(a.bufnr), vim.api.nvim_buf_get_name(b.bufnr)
        if a_file ~= b_file then return a_file < b_file end
        if a.lnum ~= b.lnum then return a.lnum < b.lnum end
        return a.col < b.col
    end)
    local rendered = vim.iter(diagnostics)
        :map(function(d) return d.user_data.lsp.data.rendered end)
        :join('')

    if all_diagnostics_buf and vim.api.nvim_buf_is_valid(all_diagnostics_buf) then
        vim.api.nvim_buf_delete(all_diagnostics_buf, { force = true })
    end
    all_diagnostics_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[all_diagnostics_buf].bufhidden = 'wipe'
    vim.api.nvim_buf_set_name(all_diagnostics_buf, 'rust://diagnostics')
    vim.cmd('botright split')
    vim.api.nvim_win_set_buf(0, all_diagnostics_buf)
    -- A terminal buffer turns rustc's ANSI colours into highlights.
    local chan = vim.api.nvim_open_term(all_diagnostics_buf, {})
    vim.api.nvim_chan_send(chan, (vim.trim(rendered):gsub('\n', '\r\n')))
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = all_diagnostics_buf, desc = 'Close' })
end

return {
    {
        -- rust-analyzer client with Rust-only extras (runnables, macro
        -- expansion, full rustc error output). Sets itself up on the first
        -- .rs buffer; do not also enable lspconfig's rust_analyzer.
        'mrcjkb/rustaceanvim',
        version = '^9',
        lazy = false,
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(_, bufnr)
                        local function map(lhs, cmd, desc)
                            vim.keymap.set('n', lhs, '<cmd>RustLsp ' .. cmd .. '<CR>',
                                { buffer = bufnr, desc = desc })
                        end
                        map('<leader>rr', 'runnables', 'Rust runnables')
                        map('<leader>rt', 'testables', 'Rust tests')
                        map('<leader>rd', 'renderDiagnostic current', 'Rust full error')
                        map('<leader>re', 'explainError current', 'Rust explain error')
                        map('<leader>rm', 'expandMacro', 'Rust expand macro')
                        vim.keymap.set('n', '<leader>rD', show_all_diagnostics,
                            { buffer = bufnr, desc = 'Rust full errors (all)' })
                    end,
                    default_settings = {
                        ['rust-analyzer'] = {
                            -- Run clippy instead of plain `cargo check` on save.
                            check = { command = 'clippy' },
                        },
                    },
                },
            }
        end,
    },
    {
        -- Cargo.toml: latest versions inline, crate/version/feature
        -- completion, and upgrade actions through the existing K / <F4> keys.
        'saecki/crates.nvim',
        tag = 'stable',
        event = { 'BufRead Cargo.toml' },
        opts = {
            -- The stable tag predates crates.nvim's 'winborder' support and
            -- defaults to no border; match the rest of the config.
            popup = { border = 'rounded' },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
}
