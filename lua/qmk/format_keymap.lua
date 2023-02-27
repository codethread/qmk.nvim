local E = require 'qmk.errors'
local preview = require 'qmk.create_preview'

---@param layout qmk.LayoutKeyInfo[][]
---@param keys string[]
---@return qmk.LayoutKeyMapInfo[][]
local function map_keys_to_grid(layout, keys)
	local key_idx = 0
	local mapped = {}
	for row_i, row in pairs(layout) do
		mapped[row_i] = {}
		for _, key in pairs(row) do
			if key.type == 'gap' then
				table.insert(mapped[row_i], key)
			else
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
	end
	assert(key_idx == #keys, E.config_mismatch)
	return mapped
end

---@param layout qmk.LayoutKeyMapInfo[][]
---@return number[]
local function get_largest_per_column(layout)
	local width = #layout[1]
	local height = #layout

	local column_sizes = {}
	for col = 1, width do
		local longest_key = 1
		for row = 1, height do
			local key = layout[row][col]
			if key.type == 'key' then
				if #key.key > longest_key then longest_key = #key.key end
			end
		end
		column_sizes[col] = longest_key
	end
	return column_sizes
end

---@param row qmk.LayoutKeyMapInfo[]
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
	local layout_grid = map_keys_to_grid(options.layout, keys)
	local largest_in_column = get_largest_per_column(layout_grid)

	for _, row in pairs(layout_grid) do
		for col_i, key in pairs(row) do
			key.span = largest_in_column[col_i]
		end
	end

	-- repeat of block above, refactor someday
	local preview_layout_grid = map_keys_to_grid(
		options.layout,
		vim.tbl_map(
			function(key) return get_key_text(key, options.comment_preview.keymap_overrides) end,
			keys
		)
	)
	local largest_in_preview_column = get_largest_per_column(preview_layout_grid)
	for _, row in pairs(preview_layout_grid) do
		for col_i, key in pairs(row) do
			key.span = largest_in_preview_column[col_i]
		end
	end

	local comment = {}
	if options.comment_preview.position ~= 'none' then
		for _, row in pairs(preview_layout_grid) do
			local str = preview.join_comment_row(row, options.comment_preview)
			-- str = idx ~= #layout_grid and str .. ',' or str
			table.insert(comment, str)
			local divider = '─'
			table.insert(comment, '//' .. string.rep(divider, #str))
		end
	end

	local output = {}
	for idx, row in pairs(layout_grid) do
		local str = join_row(row, options.spacing)
		str = idx ~= #layout_grid and str .. ',' or str
		table.insert(output, str)
	end

	return vim.tbl_flatten {
		comment,
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		output,
	}
end

return format_keymap

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.LayoutKeyMapInfo
---@field width number
---@field align? string
---@field type 'key' | 'span' | 'gap'
---@field key string
---@field key_index number
---@field span? number
