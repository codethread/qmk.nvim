local E = require 'qmk.errors'
local utils = require 'qmk.utils'
local config = require 'qmk.config.default'
local key_map = require 'qmk.config.key_map'
local sort = require 'qmk.config.sort'
local validate = require 'qmk.config.validate'
local assert = utils.assert

local M = {}

---@param layout qmk.UserLayout
---@return qmk.LayoutPlan
function M.parse_layout(layout)
	assert(#layout > 0, E.layout_empty)
	local result = {}
	for _, row in pairs(layout) do
		assert(#row > 0, E.layout_row_empty)
		-- check for trailing whitespace
		assert(not vim.startswith(row, ' '), E.layout_trailing_whitespace)
		assert(not vim.endswith(row, ' '), E.layout_trailing_whitespace)
		-- check for two white spaces in a row
		local invalid_whitespace = string.find(row, '  ', 1, true)
		assert(not invalid_whitespace, E.layout_double_whitespace)

		---@diagnostic disable-next-line: missing-parameter
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
	assert(user_config, E.config_missing)
	assert(user_config.name and user_config.layout, E.config_missing_required)

	---@type qmk.Config
	local merged_config = vim.tbl_deep_extend('force', config.default_config, user_config)
	validate(merged_config, config.default_config)

	merged_config.layout = M.parse_layout(merged_config.layout)
	local keymaps =
		vim.tbl_extend('force', {}, key_map, merged_config.comment_preview.keymap_overrides)
	return vim.tbl_deep_extend(
		'force',
		merged_config,
		{ comment_preview = { keymap_overrides = sort(keymaps) } }
	)
end

---Struct to represent a single key in a qmk.Layout
---@class qmk.LayoutPlanKey
---@field width number
---@field align? string
---@field type 'key' | 'span' | 'gap' #TODO: support space and gap

---Struct to represent the users desired layout
---@alias qmk.LayoutPlan qmk.LayoutPlanKey[][]

---The users config after parsing
---@class qmk.Config
---@field name string # name of the layout macro, this is used to find the layout in the keymap
---@field auto_format_pattern string # autocommand pattern to match against for auto formatting, e.g. '*keymap.c'
---@field keymap_qmk.LayoutPlang # path to the keymap file, must be absolute, used for rendering the layout as a popup
---@field layout qmk.Layout
---@field spacing number
---@field comment_preview qmk.Preview

---@class qmk.Preview
---@field position 'top' | 'bottom' | 'none' | 'inside'
---@field keymap_overrides qmk.KeymapList # table of keymap overrides, e.g. { KC_ESC = 'Esc' }
---@field symbols qmk.PreviewSymbols

return M
