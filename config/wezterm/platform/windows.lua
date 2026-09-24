local M = {}

function M.apply(config, wezterm)
    config.default_domain = "WSL:FedoraLinux-42"
    config.window_close_confirmation = "NeverPrompt"

    config.font_size = 14.0
    config.window_background_opacity = 0.65
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
