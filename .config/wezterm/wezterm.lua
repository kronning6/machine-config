local current = require 'themes/current'
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 20,
  bottom = 20,
}
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font('JetBrains Mono', { weight = 'DemiBold' })
config.font_size = 14.0

config.bypass_mouse_reporting_modifiers = 'CMD'

config.keys = {
  -- Disable keybinding to open tabs
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

current.apply_to_config(config)

return config
