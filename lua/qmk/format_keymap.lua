--- maps keys into the layout
--- e.g
--- ```
--- keys = { 'A', 'Some', 'Key', 'B', 'Foo', Bar', 'S', 'M' },
--- layout = {
---   { 'x', 'x', '_', 'x', 'x' },
---   { 'x', 'x', '_', 'x', 'x' },
--- }
--- ```
--- becomes
--- ```
--- {
---   { 'A', 'Some', ' ', 'Key', 'B' },
---   { 'Foo', Bar', ' ', 'S', 'M' },
--- }
--- ```
---@param layout qmk.UserLayout
---@param keys string[]
---@return string[][]
local function map_keys_to_layout(layout, keys)
	local i = 0

	return vim.tbl_map(function(row)
		return vim.tbl_map(function(key)
			if key == '_' then
				return '_'
			else
				i = i + 1
				return keys[i]
			end
		end, row)
	end, layout)
end

---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local spacing = options.spacing
	local space_key = ' ' -- TODO: get from buffer, could be tab
	local space = space_key:rep(spacing)

	local layout = options.layout

	local output = {}

	local key_layout = map_keys_to_layout(layout, keymap.keys)

	local width = #key_layout[1]
	local height = #key_layout

	-- move through all rows at the same time by colum, padding width by longest key
	local current_row = 1

	for col = 1, width do
		local longest_key = 1

		for row = 1, height do
			local key = key_layout[row][col]
			if #key > longest_key then longest_key = #key end
		end

		for row = 1, height, 1 do
			local key = key_layout[row][col]

			if key == '_' then
				output[row] = output[row] .. space
			else
				if col == 1 then
					-- start with space
					output[row] = space
				end

				if col == width then
					-- first column so no comma
					output[row] = output[row] .. key .. string.rep(' ', longest_key - #key)
				elseif col == 1 then
					-- last column so trailing comma
					output[row] = output[row] .. ' , ' .. key .. ','
				else
					output[row] = output[row] .. ' , ' .. key .. string.rep(' ', longest_key - #key)
				end
			end
		end
	end

	return {
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		output,
	}
end

return format_keymap
