---@param row qmk.LayoutGridCell[]
---@param divide number
---@return string
local function join_row(row, divide)
	local str = ''
	local current_key = { key_index = 0 }
	local comma = ' , '
	local comma_width = #comma

	for i, key in pairs(row) do
		-- simple case, just print the key
		if key.type == 'key' then
			str = str
				.. key.key
				.. string.rep(' ', key.span - #key.key)
				.. (i == #row and '' or comma)
		end

		if key.type == 'gap' then str = str .. string.rep(' ', divide) end

		if key.type == 'span' then
			if current_key.key_index ~= key.key_index then
				-- new key
				current_key = key
			else
				current_key.span = current_key.span + key.span + comma_width
			end

			-- peak ahead and see if next key is the same
			-- if not this is the last key in the span
			if not (i + 1 <= #row and row[i + 1].key_index == key.key_index) then
				-- alignment is a string like 1/3 or 2/3
				---@diagnostic disable-next-line: missing-parameter
				local ratio = vim.split(key.align, '/')
				local nom = tonumber(ratio[1])
				local denom = tonumber(ratio[2])
				if nom == 1 then
					-- left align
					str = str
						.. current_key.key
						.. string.rep(' ', current_key.span - #current_key.key)
						.. (i == #row and '' or comma)
				elseif nom == denom then
					-- right align
					str = str
						.. string.rep(' ', current_key.span - #current_key.key)
						.. current_key.key
						.. (i == #row and '' or comma)
				else
					-- center align
					local remainder = current_key.span - #current_key.key
					local half = math.floor(remainder / 2)
					local centered = string.rep(' ', half)
						.. current_key.key
						.. string.rep(' ', half)
					local padding = string.rep(' ', current_key.span - string.len(centered))

					str = str .. centered .. padding .. (i == #row and '' or comma)
				end
			end
		end
	end
	return str
end

---@param layout qmk.LayoutGrid
---@param spacing number
---@return string[]
local function print_rows(layout, spacing)
	local output = {}
	local grid = layout:cells()
	for idx, row in pairs(grid) do
		local str = join_row(row, spacing)
		str = idx ~= #grid and str .. ',' or str
		table.insert(output, str)
	end
	return output
end

return print_rows
