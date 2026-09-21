return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local autoformat_filetypes = {
            lua = true,
            python = true,
            go = true,
        }

        local fmt_group = vim.api.nvim_create_augroup('UserLspFormat', { clear = true })

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                if not autoformat_filetypes[vim.bo[args.buf].filetype] then return end

                -- One autocmd per buffer, not per client: several servers attach
                -- to the same buffer (basedpyright + ruff) and only one formats.
                vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = args.buf })
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = fmt_group,
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({
                            bufnr = args.buf,
                            timeout_ms = 3000,
                            formatting_options = {
                                tabSize = vim.bo[args.buf].shiftwidth,
                                insertSpaces = vim.bo[args.buf].expandtab,
                            },
                            -- Checked here, not at LspAttach: a server's
                            -- capabilities are not settled yet when it attaches,
                            -- so testing this any earlier silently skips ruff.
                            filter = function(client)
                                return client:supports_method('textDocument/formatting')
                            end,
                        })
                    end,
                })
            end
        })

        -- Go: organise imports on save (gopls exposes this as a code action).
        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.go',
            callback = function()
                local params = vim.lsp.util.make_range_params(0, 'utf-8')
                params.context = { only = { 'source.organizeImports' } }
                local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
                for _, res in pairs(results or {}) do
                    for _, action in pairs(res.result or {}) do
                        if action.edit then
                            vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
                        end
                    end
                end
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.HINT] = '⚑',
                    [vim.diagnostic.severity.INFO] = '»',
                },
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
            end,
        })

        -- Give every server nvim-cmp's completion capabilities.
        vim.lsp.config('*', {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })

        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = { vim.env.VIMRUNTIME },
                        checkThirdParty = false,
                    },
                },
            },
        })

        vim.lsp.config('basedpyright', {
            settings = {
                basedpyright = {
                    -- 'standard' stays useful without the wall of errors
                    -- 'all' produces on untyped code.
                    analysis = {
                        typeCheckingMode = 'standard',
                        diagnosticMode = 'openFilesOnly',
                        inlayHints = {
                            variableTypes = true,
                            functionReturnTypes = true,
                        },
                    },
                },
            },
        })

        -- ruff handles lint + format; basedpyright owns types and hover.
        vim.lsp.config('ruff', {
            on_attach = function(client)
                client.server_capabilities.hoverProvider = false
            end,
        })

        vim.lsp.config('gopls', {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        unusedwrite = true,
                        nilness = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                    -- gopls ships these off; without them Go gets
                    -- treesitter colours only, no resolved-symbol layer.
                    semanticTokens = true,
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "basedpyright",
                "ruff",
                "gopls",
            },
            automatic_enable = true,
        })

        local cmp = require('cmp')

        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    if n == 'nvim_lsp' then
                        item.menu = '[LSP]'
                    else
                        item.menu = string.format('[%s]', n)
                    end
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-d>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<C-b>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
        })
    end
}
