local M = {}

---@class qmk.UserConfig
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field layout ('x' | '_')[][]
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
	auto_format_pattern = '*keymap.c',
	keymap_path = '',
	comment_preview = {
		position = 'none',
		keymap_overrides = {},
	},
}

---@class qmk.Config
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field layout ('x' | '_')[][]
---@field auto_format_pattern string # autocommand pattern to match against for auto formatting, e.g. '*keymap.c'
---@field keymap_path string # path to the keymap file, must be absolute, used for rendering the layout as a popup
---@field comment_preview qmk.UserPreview

---@class qmk.Preview
---@field position 'top' | 'bottom' | 'none'
---@field keymap_overrides table<string, string> # table of keymap overrides, e.g. { KC_ESC = 'Esc' }

return M
