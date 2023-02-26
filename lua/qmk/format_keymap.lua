local P = vim.pretty_print

---@param layout qmk.UserLayout
---@return  qmk.LayoutKeyInfo[][]
local function parse_layout(layout)
	local result = {}
	for _, row in pairs(layout) do
		local keys = vim.split(row, ' ')
		local row_info = vim.tbl_map(function(key)
			-- if key == '.' then return { width = 1, type = 'empty' } end
			if key == 'x' then return { width = 1, type = 'key' } end

			local invalid = string.find(key, '[^x.^]')
			assert(invalid == nil, 'invalid layout, expected x, . or ^')
			-- TODO fix find index isnt right
			local i = string.find(key, '^')
			assert(i, 'invalid layout, expected a ^ in the key')
			return {
				width = (string.len(key) + 1) / 2,
				type = 'span',
				align = tostring(i) .. '/' .. tostring(string.len(key)),
			}
		end, keys)
		result[#result + 1] = row_info
	end
	return result
end

---@class qmk.LayoutKeyInfo
---@field width number
---@field align? string
---@field type 'key' | 'span''

---@class qmk.LayoutKeyMapInfo
---@field width number
---@field align? string
---@field type 'key' | 'span''
---@field key string
---@field key_index number
---@field span? number

---@param layout qmk.LayoutKeyInfo[][]
---@param keys string[]
---@return qmk.LayoutKeyMapInfo[][]
local function map_keys_to_layout(layout, keys)
	local key_idx = 0
	local mapped = {}
	for row_i, row in pairs(layout) do
		mapped[row_i] = {}
		for _, key in pairs(row) do
			key_idx = key_idx + 1
			for _ = 1, key.width do
				local info = vim.tbl_deep_extend('force', key, {
					key = keys[key_idx],
					key_index = key_idx,
				})
				table.insert(mapped[row_i], info)
			end
		end
	end
	assert(key_idx == #keys, 'not enough keys for layout')
	return mapped
end

---@param layout qmk.LayoutKeyMapInfo[][]
---@return number[]
local function get_largest_per_column(layout)
	local current_row = 1
	local width = #layout[1]
	local column_sizes = {}
	for col = 1, width do
		local longest_key = 1
		for row = 1, current_row do
			local key = layout[row][col]
			if key.type == 'key' then
				if #key.key > longest_key then longest_key = #key.key end
			end
		end
		column_sizes[col] = longest_key
	end
	return column_sizes
end

---@param cell_width number
---@param align string #e.g 1/3 2/5
---@param key_text string
local function position_cell(cell_width, align, key_text)
	-- TODO improve
	return key_text .. string.rep(' ', cell_width - #key_text)
end

---@param row qmk.LayoutKeyMapInfo[]
---@return string
local function join_row(row)
	local str = ''
	local current_key = { key_index = 0 }
	local comma = ' , '
	local comma_width = #comma

	local function print_key(text, span, isLast)
		return text .. string.rep(' ', span - #text) .. (isLast and '' or comma)
	end

	for i, key in pairs(row) do
		-- simple case, just print the key
		if key.type == 'key' then str = str .. print_key(key.key, key.span, i == #row) end
		if key.type == 'span' then
			-- new key
			if current_key.key_index ~= key.key_index then
				current_key = key
			else
				current_key.span = current_key.span + key.span + comma_width
			end

			-- peak ahead and see if next key is the same
			if i + 1 <= #row and row[i + 1].key_index == key.key_index then
				-- do nothing
			else
				-- this is the last key in the span

				str = str .. print_key(current_key.key, current_key.span, i == #row)
			end
		end
	end
	return str
end

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local keys = keymap.keys
	local layout = parse_layout(options.layout)
	local layout_map = map_keys_to_layout(layout, keys)
	local largest_in_column = get_largest_per_column(layout_map)

	for _, row in pairs(layout_map) do
		for col_i, key in pairs(row) do
			key.span = largest_in_column[col_i]
		end
	end

	return vim.tbl_flatten {
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		vim.tbl_map(join_row, layout_map),
	}
end

return format_keymap
