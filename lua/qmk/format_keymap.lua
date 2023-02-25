---@param options qmk.Config
---@param keymap qmk.Keymap
---@return string[]
local function format_keymap(options, keymap)
	local spacing = options.spacing
	local space_key = ' ' -- TODO: get from buffer, could be tab
	local space = space_key:rep(spacing)

	local layout = options.layout

	local result = {}
	-- keep track of which key in our keymap we are using, as it's a single list
	local key_i = 0

	for i_row, row in ipairs(layout) do
		-- create a new string starting with a space
		local cur = space

		for i_key, key in ipairs(row) do
			if key == '_' then
				cur = cur .. space
			else
				-- advance to the next key
				key_i = key_i + 1

				-- last key in row, don't add a comma
				local trailing = i_key == #row and '' or ' , '
				cur = cur .. keymap.keys[key_i] .. trailing
			end
		end

		-- last row in a keymap so no comma
		local trailing = i_row == #layout and '' or ','
		result[i_row] = cur .. trailing
	end

	return {
		'[' .. keymap.layer_name .. '] = ' .. keymap.layout_name .. '(',
		result,
	}
end

return format_keymap
