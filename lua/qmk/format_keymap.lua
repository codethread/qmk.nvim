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
				width = string.len(key),
				type = 'key',
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
---@field type 'key' | 'empty''

---@param layout qmk.LayoutKeyInfo[][]
---@param keys string[]
---@return string[][]
local function map_keys_to_layout(layout, keys)
	local i = 0
	local mapped = vim.tbl_map(function(row)
		return vim.tbl_flatten(vim.tbl_map(
			---@param key qmk.LayoutKeyInfo
			---@return string | string[]
			function(key)
				if key.type == 'empty' then
					return '_'
				else
					local s = {}
					i = i + 1
					for j = 1, (key.width + 1) / 2 do
						table.insert(s, j, keys[i])
					end

					return s
				end
			end,
			row
		))
	end, layout)
	assert(i == #keys, 'not enough keys for layout')
	return mapped
end

---@param layout string[][]
---@return number[]
local function get_largest_per_column(layout)
	local current_row = 1
	local width = #layout[1]
	local column_sizes = {}
	for col = 1, width do
		local longest_key = 1
		for row = 1, current_row do
			local key = layout[row][col]

			if #key > longest_key then longest_key = #key end
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

---@param row string[]
---@return string
local function join_row(row)
	local str = ''
	for i, key in pairs(row) do
		str = str .. key .. (i == #row and '' or ' , ')
	end
	return str
end

---@param col_i number
---@param key qmk.LayoutKeyInfo
---@param largest_in_column number[]
---@return number
local function get_cell_width(col_i, key, largest_in_column)
	local width = 0
	local key_width = (key.width + 1) / 2
	local comma_width = (key_width - 1) * 2
	for i = 1, key_width do
		local lookup = col_i + i - 1
		if lookup <= #largest_in_column then width = width + largest_in_column[lookup] end
	end
	return width + comma_width + 1
end

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local keys = keymap.keys
	local layout = parse_layout(options.layout)
	local layout_map = map_keys_to_layout(layout, keys)
	local largest_in_column = get_largest_per_column(layout_map)

	local output = {}
	local idx = 0

	for row_i, row in pairs(layout) do
		output[row_i] = {}
		for col_i, key in pairs(row) do
			if key.type == 'key' then
				local cell_width = get_cell_width(col_i, key, largest_in_column)
				idx = idx + 1
				local key_text = keys[idx]
				local cell = key.align and position_cell(cell_width, key.align, key_text)
					or key_text
				output[row_i][col_i] = cell
			else
				error 'invalid layout, expected key or empty (dev error)'
			end
		end
	end

	return vim.tbl_flatten {
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		vim.tbl_map(join_row, output),
	}
end

return format_keymap
