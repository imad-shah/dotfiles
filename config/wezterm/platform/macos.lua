local M = {}

function M.apply(config, wezterm)
    config.font_size = 15.0
    config.window_background_opacity = 0.9   -- [0.0, 1.0 (default)]
    config.macos_window_background_blur = 70 -- [0, ~100]
    -- config.colors = { background = "#242b38" } -- forces the color 1 way

    config.initial_rows = 45
    config.initial_cols = 140
    config.keys = require("panes").keys("CMD")
end

return M
