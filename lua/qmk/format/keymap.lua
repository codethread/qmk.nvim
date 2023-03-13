local generate = require('qmk.format.preview').generate
local LayoutGrid = require 'qmk.data.LayoutGrid'
local print_rows = require 'qmk.format.key_rows'

---find all matching key codes from the key string and replace them with the keymap value
---@param key string
---@param keymap qmk.KeymapList
---@return string
local function get_key_text(key, keymap)
	local str = key
	for _, k in ipairs(keymap) do
		-- replace the key with the override
		str = string.gsub(str, k.key, k.value)
	end
	return str
end

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local keys = keymap.keys
	local key_layout = LayoutGrid:new(options.layout, keys)

	local preview_layout = LayoutGrid:new(
		options.layout,
		vim.tbl_map(
			function(key) return get_key_text(key, options.comment_preview.keymap_overrides) end,
			keys
		)
	)
	local comment = options.comment_preview.position == 'none' and {}
		or generate(preview_layout, options.comment_preview.symbols)
	local preview = vim.tbl_map(table.concat, comment) or {}

	return vim.tbl_flatten {
		options.comment_preview.position == 'top' and preview,
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		options.comment_preview.position == 'inside' and preview,
		print_rows(key_layout, options.spacing),
		options.comment_preview.position == 'bottom' and preview,
	}
end

return format_keymap
