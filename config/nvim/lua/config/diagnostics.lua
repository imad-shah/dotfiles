-- Diagnostics in full, for when virtual text runs past the edge of the
-- window. Backs <leader>rD in plugins/rust.lua and plugins/lsp.lua.
local M = {}

local split_buf

-- Every diagnostic in `diagnostics` in one bottom split, errors first, then
-- by file and position. `render` turns one into text (ANSI colours and all)
-- ending in a blank line, as rustc renders its errors.
function M.show_in_split(name, diagnostics, render)
    table.sort(diagnostics, function(a, b)
        if a.severity ~= b.severity then return a.severity < b.severity end
        local a_file, b_file = vim.api.nvim_buf_get_name(a.bufnr), vim.api.nvim_buf_get_name(b.bufnr)
        if a_file ~= b_file then return a_file < b_file end
        if a.lnum ~= b.lnum then return a.lnum < b.lnum end
        return a.col < b.col
    end)
    local text = vim.iter(diagnostics):map(render):join('')

    if split_buf and vim.api.nvim_buf_is_valid(split_buf) then
        vim.api.nvim_buf_delete(split_buf, { force = true })
    end
    split_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[split_buf].bufhidden = 'wipe'
    vim.api.nvim_buf_set_name(split_buf, name)
    local origin_win = vim.api.nvim_get_current_win()
    vim.cmd('botright split')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, split_buf)
    -- A terminal buffer turns the ANSI colours into highlights.
    local chan = vim.api.nvim_open_term(split_buf, {})
    vim.api.nvim_chan_send(chan, (vim.trim(text):gsub('\n', '\r\n')))
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = split_buf, desc = 'Close' })
    -- Closing a full-width bottom split can hand focus to the file tree;
    -- go back to the window it was opened from, however it gets closed.
    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(win),
        once = true,
        callback = function()
            if vim.api.nvim_get_current_win() ~= win then return end
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(origin_win) then
                    vim.api.nvim_set_current_win(origin_win)
                end
            end)
        end,
    })
end

-- rustc's colours: bold, then bright red, yellow, blue, cyan, green.
local function paint(color, s) return '\27[1m\27[' .. color .. 'm' .. s .. '\27[0m' end
local BLUE = '94'
local labels = {
    [vim.diagnostic.severity.ERROR] = { 'error', '91' },
    [vim.diagnostic.severity.WARN] = { 'warning', '93' },
    [vim.diagnostic.severity.INFO] = { 'info', '96' },
    [vim.diagnostic.severity.HINT] = { 'hint', '92' },
}

-- A diagnostic that is only a message (basedpyright, ruff) laid out the way
-- rustc and `ruff check` print theirs: headline, location, the source line
-- with the range underlined, then the rest of the message.
function M.render(d)
    local label, color = unpack(labels[d.severity])
    local message = vim.split((d.message:gsub('\r', '')), '\n')
    local code = d.code and ('[' .. d.code .. ']') or ''
    local out = { paint(color, label .. code) .. '\27[1m: ' .. message[1] .. '\27[0m' }

    local num = tostring(d.lnum + 1)
    local pad = (' '):rep(#num)
    local gutter = pad .. ' ' .. paint(BLUE, '|')
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ':.')
    local line = vim.api.nvim_buf_get_lines(d.bufnr, d.lnum, d.lnum + 1, false)[1]
    if line then
        -- Tabs as four spaces, as rustc does, so the underline lines up.
        local function expand(s) return (s:gsub('\t', '    ')) end
        local span = line:sub(d.col + 1, d.end_lnum == d.lnum and d.end_col or #line)
        vim.list_extend(out, {
            pad .. paint(BLUE, '--> ') .. path .. ':' .. num .. ':' .. (vim.fn.strchars(line:sub(1, d.col)) + 1),
            gutter,
            paint(BLUE, num .. ' |') .. ' ' .. expand(line),
            gutter .. ' ' .. (' '):rep(vim.fn.strdisplaywidth(expand(line:sub(1, d.col))))
            .. paint(color, ('^'):rep(math.max(vim.fn.strdisplaywidth(expand(span)), 1))),
            gutter,
        })
    else
        table.insert(out, pad .. paint(BLUE, '--> ') .. path .. ':' .. num .. ':' .. (d.col + 1))
    end

    for i = 2, #message do
        if message[i] ~= '' then
            table.insert(out, (message[i]:gsub('^help:', paint('96', 'help') .. ':')))
        end
    end
    return table.concat(out, '\n') .. '\n\n'
end

return M
