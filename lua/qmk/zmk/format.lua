local generate = require('qmk.formatting.preview').generate
local LayoutGrid = require('qmk.data.LayoutGrid')
local key_text = require('qmk.formatting.key_text')
local key_rows = require('qmk.formatting.key_rows')

local M = {}

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return qmk.ZMKResult
function M.format_keymap(keymap, options)
	local keys = keymap.keys
	local key_layout = LayoutGrid:new(options.layout, keys)
	local comment_preview = options.comment_preview

	local preview_layout = LayoutGrid:new(
		options.layout,
		vim.tbl_map(key_text.get_key_text(comment_preview.keymap_overrides), keys)
	)
	local preview = comment_preview.position ~= 'none'
			and generate(preview_layout, comment_preview.symbols)
		or nil

	return {
		layer_name = keymap.layer_name,
		pos = keymap.pos,
		keys = key_rows.print_rows(key_layout, '   ', ''),
		preview = preview and vim.tbl_map(table.concat, preview) or nil,
	}
end

return M

---@class qmk.ZMKResult
---@field layer_name string
---@field pos qmk.Position
---@field keys string[]
---@field preview? string[]
