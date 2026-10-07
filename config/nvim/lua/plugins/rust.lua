-- Every rustc/clippy diagnostic in the workspace, rendered in full as
-- `cargo build` prints it, in one bottom split. rust-analyzer only attaches
-- the rendered text to cargo-check diagnostics, so its own native ones are
-- left out (same as `RustLsp renderDiagnostic`).
local function show_all_diagnostics()
    local diagnostics = vim.iter(vim.diagnostic.get())
        :filter(function(d) return vim.tbl_get(d, 'user_data', 'lsp', 'data', 'rendered') ~= nil end)
        :totable()
    if #diagnostics == 0 then
        vim.notify('No rendered Rust diagnostics.', vim.log.levels.INFO)
        return
    end
    require('config.diagnostics').show_in_split('rust://diagnostics', diagnostics,
        function(d) return d.user_data.lsp.data.rendered end)
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
