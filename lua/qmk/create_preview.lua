local M = {}
-- ┌─ ─ ┬ ┐
-- │
-- ├─ ─ ┼ ┤

-- └─ ─ ┴ ┘
local symbols = {
	tl = '┌',
	div = '─',
	tm = '┬',
	tr = '┐',
	sep = '│',
	lm = '├',
	m = '┼',
	rm = '┤',
	bl = '└',
	bm = '┴',
	br = '┘',
}

---@param row qmk.LayoutKeyMapInfo[]
---@param preview qmk.Preview
---@return string
function M.join_comment_row(row, preview)
	local separator = ' │  '
	local str = '// ' .. separator
	local current_key = { key_index = 0 }
	for i, key in pairs(row) do
		-- local text = preview.keymap_overrides[key.key] or key.key
		if key.type == 'gap' then
			-- ignore for now
		end

		-- simple case, just print the key
		if key.type == 'key' then
			str = str
				.. key.key
				.. string.rep(' ', key.span - #key.key)
				.. (i == #row and '' or separator)
		end
		if key.type == 'span' then
			if current_key.key_index ~= key.key_index then
				-- new key
				current_key = key
			else
				current_key.span = current_key.span + key.span + #separator
			end

			-- peak ahead and see if next key is the same
			-- if not this is the last key in the span
			if not (i + 1 <= #row and row[i + 1].key_index == key.key_index) then
				str = str
					.. current_key.key
					.. string.rep(' ', current_key.span - #current_key.key)
					.. (i == #row and '' or separator)
			end
		end
	end
	return str
end

return M
