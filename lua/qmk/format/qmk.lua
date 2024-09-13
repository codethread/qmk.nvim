local format_keymap = require('qmk.format.keymap')

---@param keymaps qmk.Keymaps
---@param options qmk.Config
---@return string[]
local function format_keymaps(keymaps, options)
	local result = {}

	for i, keymap in ipairs(keymaps.keymaps) do
		local row = { format_keymap(options, keymap) }
		if i == #keymaps.keymaps then
			table.insert(row, ')')
		else
			---@diagnostic disable-next-line: missing-parameter
			vim.list_extend(row, { '),', '' })
		end
		table.insert(result, row)
	end

	if vim.version().minor >= 10 then
		return vim.iter(result):flatten(2):totable()
	else
		---@diagnostic disable-next-line: deprecated
		return vim.tbl_flatten(result)
	end
end

return format_keymaps
