local format_keymap = require('qmk.formatting')

local M = {}

---@param keymaps qmk.Keymaps
---@param options qmk.Config
---@return string[]
function M.format_keymaps(keymaps, options)
	local result = {}

	for i, keymap in ipairs(keymaps.keymaps) do
		local row = { format_keymap.format_keymap(options, keymap) }
		if i == #keymaps.keymaps then
			table.insert(row, ')')
		else
			---@diagnostic disable-next-line: missing-parameter
			vim.list_extend(row, { '),', '' })
		end
		table.insert(result, row)
	end

	return vim.iter(result):flatten(2):totable()
end

return M
