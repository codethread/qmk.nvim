local format_keymap = require 'qmk.format_keymap'

---@param keymaps qmk.Keymaps
---@param options qmk.Config
---@return string[]
local function format_keymaps(keymaps, options)
	local result = {}

	for key, keymap in pairs(keymaps.keymaps) do
		local row = { format_keymap(options, keymap) }
		if key == #keymaps.keymaps then
			table.insert(row, ')')
		else
			vim.list_extend(row, { '),', '' })
		end
		table.insert(result, row)
	end
	return vim.tbl_flatten(result)
end

return format_keymaps
