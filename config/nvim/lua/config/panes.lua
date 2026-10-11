vim.o.title = true
vim.o.titlestring = 'nvim %t'

local wezterm = vim.fn.has('wsl') == 1 and 'wezterm.exe' or 'wezterm'

local function wezterm_cli(...)
    if vim.env.TERM_PROGRAM == 'WezTerm' and vim.fn.executable(wezterm) == 1 then
        vim.system({ wezterm, 'cli', ... })
    end
end

local directions = {
    Left = { wincmd = 'h', split = 'leftabove vsplit' },
    Right = { wincmd = 'l', split = 'rightbelow vsplit' },
    Up = { wincmd = 'k', split = 'leftabove split' },
    Down = { wincmd = 'j', split = 'rightbelow split' },
}

local function split_count()
    local count = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_win_get_config(win).relative == '' and vim.bo[buf].filetype ~= 'NvimTree' then
            count = count + 1
        end
    end
    return count
end

local function move(dir)
    local win = vim.api.nvim_get_current_win()
    vim.cmd('wincmd ' .. directions[dir].wincmd)
    if vim.api.nvim_get_current_win() == win then
        wezterm_cli('activate-pane-direction', dir)
    end
end

local function resize(dir)
    local horizontal = dir == 'Left' or dir == 'Right'
    local after = horizontal and 'l' or 'j'
    local before = horizontal and 'h' or 'k'
    local cur = vim.fn.winnr()
    local has_after = vim.fn.winnr(after) ~= cur
    if not has_after and vim.fn.winnr(before) == cur then
        wezterm_cli('adjust-pane-size', '--amount', '5', dir)
        return
    end
    local grow = (dir == 'Right' or dir == 'Down') == has_after
    local step = horizontal and 4 or 2
    vim.cmd((horizontal and 'vertical ' or '') .. 'resize ' .. (grow and '+' or '-') .. step)
end

local function close()
    if split_count() > 1 then
        vim.cmd('close')
    else
        vim.cmd('quit')
    end
end

local function zoom()
    if vim.t.zoom_restore then
        vim.cmd(vim.t.zoom_restore)
        vim.t.zoom_restore = nil
    elseif split_count() > 1 then
        vim.t.zoom_restore = vim.fn.winrestcmd()
        vim.cmd('wincmd | | wincmd _')
    else
        wezterm_cli('zoom-pane', '--toggle')
    end
end

local function map(lhs, fn, desc)
    vim.keymap.set('n', lhs, fn, { desc = desc })
end

for dir, d in pairs(directions) do
    map('<C-S-' .. dir .. '>', function() vim.cmd(d.split) end, 'Split ' .. dir:lower())
    map('<C-' .. dir .. '>', function() move(dir) end, 'Move ' .. dir:lower())
    map('<A-' .. dir .. '>', function() resize(dir) end, 'Resize ' .. dir:lower())
end
map('<C-S-w>', close, 'Close split')
map('<C-S-z>', zoom, 'Zoom split')
