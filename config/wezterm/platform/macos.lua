local M = {}

function M.apply(config, wezterm)
    config.font_size = 15.0
    config.window_background_opacity = 0.9
    config.macos_window_background_blur = 80
    config.colors = { background = "#303950" }

    config.initial_rows = 45
    config.initial_cols = 140
    config.keys = require("panes").keys("CMD")
end

return M
