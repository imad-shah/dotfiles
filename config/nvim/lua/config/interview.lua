-- :Interview turns Python buffers into the Google Doc that coding interviews
-- are run in: no highlighting, no language servers (so no diagnostics, hover,
-- inlay hints or format-on-save), no completion and no auto-closed brackets.
-- Run it again to get everything back. It lasts until Neovim exits.

local filetypes = { 'python' }

local active = false
local stopped_servers = {} -- LSP configs switched off, to switch back on
local group = vim.api.nvim_create_augroup('Interview', { clear = true })

local function buffers()
    return vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.list_contains(filetypes, vim.bo[buf].filetype)
    end, vim.api.nvim_list_bufs())
end

-- Stopping treesitter puts the regex syntax back, so that goes after it.
local function plain(buf)
    vim.treesitter.stop(buf)
    vim.bo[buf].syntax = 'OFF'
end

local function enable()
    for _, ft in ipairs(filetypes) do
        for _, config in ipairs(vim.lsp.get_configs({ enabled = true, filetype = ft })) do
            table.insert(stopped_servers, config.name)
        end
    end
    -- Also stops the running clients, which clears their diagnostics.
    vim.lsp.enable(stopped_servers, false)
    -- Except clients still starting up (say, for a new file whose filetype was
    -- set before :Interview ran): stop those as they attach.
    vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and vim.list_contains(stopped_servers, client.name) then
                client:stop()
            end
        end,
    })

    require('cmp').setup.filetype(filetypes, { enabled = false })
    require('nvim-autopairs').disable()
    require('nvim-highlight-colors').turnOff()

    for _, buf in ipairs(buffers()) do
        plain(buf)
    end
    -- Created now rather than at startup so it runs after the FileType
    -- autocmds that start treesitter and regex syntax, and can undo them.
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = filetypes,
        callback = function(args) plain(args.buf) end,
    })
end

local function disable()
    vim.api.nvim_clear_autocmds({ group = group })
    vim.lsp.enable(stopped_servers)
    stopped_servers = {}

    require('cmp').setup.filetype(filetypes, {})
    require('nvim-autopairs').enable()
    require('nvim-highlight-colors').turnOn()

    -- Setting the filetype again redoes highlighting the way opening the file does.
    for _, buf in ipairs(buffers()) do
        vim.bo[buf].filetype = vim.bo[buf].filetype
    end
end

local function toggle()
    active = not active
    if active then enable() else disable() end
    vim.notify('Interview mode ' .. (active and 'on' or 'off'))
end

vim.api.nvim_create_user_command('Interview', toggle,
    { desc = 'Toggle interview mode: plain Python, no LSP, no completion' })
