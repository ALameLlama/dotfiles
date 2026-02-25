-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Catppuccin Mocha'
-- config.colors = {
--   indexed = {
--     [16] = "#00000080",
--   }
-- }
config.color_scheme = "Catppuccin Mocha (Gogh)"

-- config.font = wezterm.font('FiraCode Nerd Font', { weight = 'Bold' })
config.font = wezterm.font("Maple Mono NF", { weight = "Bold" })

-- and finally, return the configuration to wezterm
return config
