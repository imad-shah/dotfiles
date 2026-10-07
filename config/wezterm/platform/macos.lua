local M = {}

function M.apply(config, wezterm)
    config.font_size = 15.0
    config.window_background_opacity = 0.8
    config.macos_window_background_blur = 50

    config.initial_rows = 45
    config.initial_cols = 140
    config.keys = {
        -- Split right
        {
            key = 'RightArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Right',
                size = { Percent = 50 },
            },
        },

        -- Split left
        {
            key = 'LeftArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Left',
                size = { Percent = 50 },
            },
        },

        -- Split up
        {
            key = 'UpArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Up',
                size = { Percent = 50 },
            },
        },

        -- Split down
        {
            key = 'DownArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Down',
                size = { Percent = 50 },
            },
        },
        -- Navigate between panes
        {
            key = 'RightArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'LeftArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'UpArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'DownArrow',
            mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        -- Close current pane
        {
            key = 'w',
            mods = 'CMD|SHIFT',
            action = wezterm.action.CloseCurrentPane {
                confirm = false,
            },
        },
        {
            key = 'z',
            mods = 'CMD|SHIFT',
            action = wezterm.action.TogglePaneZoomState,
        },
    }
end

return M
