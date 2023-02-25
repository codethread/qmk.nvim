local Layout = require 'qmk/Layout'

local M = {}

---@alias qmk.UserKey ('x' | '_')
---@alias qmk.UserLayout qmk.UserKey[][]

---@class qmk.UserConfig
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field layout qmk.UserLayout
---@field spacing? number
---@field auto_format_pattern? string # autocommand pattern to match against for auto formatting, e.g. '*keymap.c'
---@field keymap_path? string # path to the keymap file, must be absolute, used for rendering the layout as a popup
---@field comment_preview? qmk.UserPreview

---@class qmk.UserPreview
---@field position 'top' | 'bottom' | 'none'
---@field keymap_overrides? table<string, string> # table of keymap overrides, e.g. { KC_ESC = 'Esc' }

---@type qmk.Config
M.default_config = {
	name = '',
	layout = {},
	spacing = 4, -- this can likely be pulled from the buffer
	auto_format_pattern = '*keymap.c',
	keymap_path = '',
	comment_preview = {
		position = 'none',
		keymap_overrides = {},
	},
}

---parse the user config into qmk config
---@param user_config qmk.UserConfig
---@return qmk.Config
function M.parse(user_config)
	return {
		name = user_config.name,
		auto_format_pattern = user_config.auto_format_pattern,
		keymap_path = user_config.keymap_path,
		comment_preview = user_config.comment_preview,
		layout = Layout:new(user_config.layout),
	}
end

---@class qmk.Config
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field auto_format_pattern string # autocommand pattern to match against for auto formatting, e.g. '*keymap.c'
---@field keymap_path string # path to the keymap file, must be absolute, used for rendering the layout as a popup
---@field layout qmk.UserLayout
---@field spacing number
---@field comment_preview qmk.UserPreview

---@class qmk.Preview
---@field position 'top' | 'bottom' | 'none'
---@field keymap_overrides table<string, string> # table of keymap overrides, e.g. { KC_ESC = 'Esc' }

return M
