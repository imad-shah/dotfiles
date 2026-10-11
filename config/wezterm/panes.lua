local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Neovim titles itself "nvim <file>"; zsh resets the title at every prompt.
local function is_nvim(pane)
    return pane:get_title():find("^nvim") ~= nil
end

local function either(nvim_action, wezterm_action)
    return wezterm.action_callback(function(window, pane)
        window:perform_action(is_nvim(pane) and nvim_action or wezterm_action, pane)
    end)
end

-- `mod` is CTRL on Windows and CMD on macOS.
function M.keys(mod)
    local keys = {}
    for _, dir in ipairs({ "Left", "Right", "Up", "Down" }) do
        local arrow = dir .. "Arrow"
        table.insert(keys, {
            key = arrow,
            mods = mod .. "|SHIFT",
            action = either(act.SendKey { key = arrow, mods = "CTRL|SHIFT" },
                act.SplitPane { direction = dir, size = { Percent = 50 } }),
        })
        table.insert(keys, {
            key = arrow,
            mods = mod,
            action = either(act.SendKey { key = arrow, mods = "CTRL" }, act.ActivatePaneDirection(dir)),
        })
        table.insert(keys, {
            key = arrow,
            mods = "ALT",
            action = either(act.SendKey { key = arrow, mods = "ALT" }, act.AdjustPaneSize { dir, 5 }),
        })
    end
    -- Terminals can't tell Ctrl+Shift+letter from Ctrl+letter, so send
    -- Neovim the CSI u form of Ctrl+Shift+w / Ctrl+Shift+z.
    table.insert(keys, {
        key = "w",
        mods = mod .. "|SHIFT",
        action = either(act.SendString("\x1b[119;6u"), act.CloseCurrentPane { confirm = false }),
    })
    table.insert(keys, {
        key = "z",
        mods = mod .. "|SHIFT",
        action = either(act.SendString("\x1b[122;6u"), act.TogglePaneZoomState),
    })
    return keys
end

return M
