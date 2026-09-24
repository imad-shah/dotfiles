local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

if wezterm.target_triple:find("windows") then
    require("platform.windows").apply(config, wezterm)
elseif wezterm.target_triple:find("darwin") then
    require("platform.macos").apply(config, wezterm)
end

return config
