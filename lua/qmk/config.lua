local E = require 'qmk.errors'
local K = require 'qmk.key_map'

local M = {}

---@alias qmk.UserLayout string[]

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
---@field symbols? table<string, string>

---@type qmk.Config
M.default_config = {
	name = '',
	layout = { {} },
	spacing = 4, -- this can likely be pulled from the buffer
	auto_format_pattern = '*keymap.c',
	keymap_path = '',
	comment_preview = {
		position = 'none',
		keymap_overrides = {},
		symbols = {
			tl = '┌',
			div = '─',
			tm = '┬',
			tr = '┐',
			sep = '│',
			ml = '├',
			mm = '┼',
			mr = '┤',
			bl = '└',
			bm = '┴',
			br = '┘',
		},
	},
}

---@param layout qmk.UserLayout
---@return qmk.LayoutKeyInfo[][]
function M.parse_layout(layout)
	local result = {}
	for _, row in pairs(layout) do
		-- check for trailing whitespace
		assert(not vim.startswith(row, ' '), E.layout_trailing_whitespace)
		assert(not vim.endswith(row, ' '), E.layout_trailing_whitespace)
		-- check for two white spaces in a row
		local invalid_whitespace = string.find(row, '  ', 1, true)
		assert(not invalid_whitespace, E.layout_double_whitespace)

		local keys = vim.split(row, ' ')
		local row_info = vim.tbl_map(function(key)
			if key == '|' then return { width = 1, type = 'gap' } end
			if key == 'x' then return { width = 1, type = 'key' } end

			local invalid = string.find(key, '[^x^]')
			assert(not invalid, E.config_invalid_symbol)
			local i = string.find(key, '^', 1, true)
			assert(i, E.config_invalid_span)
			return {
				width = (string.len(key) + 1) / 2,
				type = 'span',
				align = tostring(i) .. '/' .. tostring(string.len(key)),
			}
		end, keys)
		result[#result + 1] = row_info
	end
	return result
end

---@param user_config qmk.UserConfig
---@return qmk.Config
function M.parse(user_config)
	if not user_config then error(E.config_missing) end
	if not user_config.name or not user_config.layout then error 'name and layout are required' end
	---@type qmk.Config
	local merged_config = vim.tbl_deep_extend('force', M.default_config, user_config)

	merged_config.layout = M.parse_layout(merged_config.layout)
	local keymaps =
		vim.tbl_extend('force', {}, K.key_map, merged_config.comment_preview.keymap_overrides)
	return vim.tbl_deep_extend(
		'force',
		merged_config,
		{ comment_preview = { keymap_overrides = K.sort(keymaps) } }
	)
end

---@class qmk.LayoutKeyInfo
---@field width number
---@field align? string
---@field type 'key' | 'span' | 'gap' #TODO: support space and gap

---@class qmk.Config
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field auto_format_pattern string # autocommand pattern to match against for auto formatting, e.g. '*keymap.c'
---@field keymap_path string # path to the keymap file, must be absolute, used for rendering the layout as a popup
---@field layout qmk.LayoutKeyInfo[][]
---@field spacing number
---@field comment_preview qmk.Preview

---@class qmk.Preview
---@field position 'top' | 'bottom' | 'none'
---@field keymap_overrides qmk.KeymapList # table of keymap overrides, e.g. { KC_ESC = 'Esc' }
---@field symbols table<string, string>

return M
