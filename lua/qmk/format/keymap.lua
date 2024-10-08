local generate = require('qmk.format.preview').generate
local LayoutGrid = require('qmk.data.LayoutGrid')
local print_rows = require('qmk.format.key_rows')
local get_key_text = require('qmk.format.get_key_text')
local utils = require('qmk.utils')

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local keys = keymap.keys
	local key_layout = LayoutGrid:new(options.layout, keys)
	local comment_preview = options.comment_preview

	local preview_layout = LayoutGrid:new(
		options.layout,
		vim.tbl_map(get_key_text(comment_preview.keymap_overrides), keys)
	)
	local comment = comment_preview.position ~= 'none'
			and generate(preview_layout, comment_preview.symbols)
		or {}
	local preview = vim.tbl_map(table.concat, comment) or {}

	local result = {
		comment_preview.position == 'top' and preview,
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		comment_preview.position == 'inside' and preview,
		print_rows(key_layout),
		comment_preview.position == 'bottom' and preview,
	}

	return vim.iter(result):filter(utils.remove_false):flatten(1):totable()
end

return format_keymap
