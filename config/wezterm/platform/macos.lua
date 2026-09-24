local M = {}

function M.apply(config, wezterm)
    config.font_size = 15.0
    config.window_background_opacity = 0.8
    config.macos_window_background_blur = 50

    config.initial_rows = 45
    config.initial_cols = 140
end

return M
