local format_keymap = require('qmk.format.keymap')
local format_utils = require('qmk.format.utils')

---@param keymaps qmk.Keymaps
---@param options qmk.Config
---@return string[]
local function format_keymaps(keymaps, options)
	local result = {}
	local indent = format_utils.get_indent_string(options)

	for i, keymap in ipairs(keymaps.keymaps) do
		local row = { format_keymap(options, keymap) }
		if i == #keymaps.keymaps then
			table.insert(row, indent .. ')')
		else
			---@diagnostic disable-next-line: missing-parameter
			vim.list_extend(row, { indent .. '),', '' })
		end
		table.insert(result, row)
	end

	return vim.iter(result):flatten(2):totable()
end

return format_keymaps
