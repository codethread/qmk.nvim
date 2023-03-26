local generate = require('qmk.format.preview').generate
local LayoutGrid = require('qmk.data.LayoutGrid')
local get_key_text = require('qmk.format.get_key_text')
local print_rows = require('qmk.format.key_rows')

-----@param layout qmk.LayoutGrid
-----@return string[]
--local function print_rows(layout)
--	return {}
--end

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return qmk.ZMKResult
local function format_keymap(options, keymap)
	local keys = keymap.keys
	local key_layout = LayoutGrid:new(options.layout, keys)
	local comment_preview = options.comment_preview

	local preview_layout = LayoutGrid:new(
		options.layout,
		vim.tbl_map(get_key_text(comment_preview.keymap_overrides), keys)
	)

	return {
		layer_name = keymap.layer_name,
		pos = keymap.pos,
		keys = print_rows(key_layout, '   ', ''),
		preview = comment_preview.position ~= 'none'
				and generate(preview_layout, comment_preview.symbols)
			or nil,
	}
end

---@param keymaps qmk.Keymaps
---@param options qmk.Config
---@return qmk.ZMKResult[]
local function format_keymaps(keymaps, options)
	return vim.tbl_map(function(keymap)
		return format_keymap(options, keymap)
	end, keymaps.keymaps)
end

return format_keymaps

---@class qmk.ZMKResult
---@field layer_name string
---@field pos qmk.Position
---@field keys string[]
---@field preview? string[]
