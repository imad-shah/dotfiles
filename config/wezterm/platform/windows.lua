local M = {}

function M.apply(config, wezterm)
    config.default_domain = "WSL:FedoraLinux-42"
    config.window_close_confirmation = "NeverPrompt"

    config.font_size = 13.0
    config.window_background_opacity = 0.6
    config.text_background_opacity = 1.0
    config.win32_system_backdrop = "Acrylic"

    config.initial_rows = 50
    config.initial_cols = 150

    config.keys = {
        {
            key = "v",
            mods = "CTRL",
            action = wezterm.action.PasteFrom("Clipboard"),
        },
        {
            key = "Backspace",
            mods = "CTRL",
            action = wezterm.action.SendString("\x17"),
        },
        {
            key = "r",
            mods = "CTRL",
            action = wezterm.action.SendString("\x1f"),
        },
        -- Split right
        {
            key = 'RightArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Right',
                size = { Percent = 50 },
            },
        },

        -- Split left
        {
            key = 'LeftArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Left',
                size = { Percent = 50 },
            },
        },

        -- Split up
        {
            key = 'UpArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Up',
                size = { Percent = 50 },
            },
        },

        -- Split down
        {
            key = 'DownArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Down',
                size = { Percent = 50 },
            },
        },
        -- Navigate between panes
        {
            key = 'RightArrow',
            mods = 'CTRL',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'LeftArrow',
            mods = 'CTRL',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'UpArrow',
            mods = 'CTRL',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'DownArrow',
            mods = 'CTRL',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        -- Close current pane
        {
            key = 'w',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.CloseCurrentPane {
                confirm = false,
            },
        },
        {
            key = 'z',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.TogglePaneZoomState,
        },
    }

    config.colors = {
        selection_fg = "#000000",
        selection_bg = "#fffacd",
    }

    wezterm.on("gui-startup", function(cmd)
        local screen = wezterm.gui.screens().active

        local width = 1400
        local height = 900

        local x = (screen.width - width) / 2
        local y = (screen.height - height) / 2

        local _, _, window = wezterm.mux.spawn_window(cmd or {
            position = {
                x = math.floor(x),
                y = math.floor(y),
                origin = "ActiveScreen",
            },
        })

        window:gui_window():set_inner_size(width, height)
    end)
end

return M
