local ts = vim.treesitter
--[[
  ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
  │//││││F│G/*|*/│H│J│││││
  ├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
  │ Esc  │   1  │   2  │   3  │   4  │KC 5/*|*/│   6  │   7  │   8  │   9  │   0  │  F12 │
  ├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
  │ Tab  │   Q  │   W  │   E  │   R  │KC T/*|*/│   Y  │   U  │   I  │   O  │   P  │Enter │
  ├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
  │CTL T(KC ESC│   A  │   S  │   D  │   F  │KC G/*---*/│   H  │   J  │   K  │   L  │   ;  │   '  │
  ├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
  │ Shft │   Z  │   X  │   C  │   V  │KC B/*|*/│   N  │   M  │   ,  │   .  │   /  │ Shft │
  ├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
  │      │ Ctrl │ Alt  │ Gui  │LT( Lower │KC ENT│SFT T(KC TAB)/*|*/│LT( Raise │KC BSPC│LT( Lower │KC SPC│ALT T(KC ESC│ Alt  │ Ctrl │ RAISE│
  └──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘

--]]

-- look through the keymap file and find all layouts, capturing
-- the keymap name and a list of all keys for formatting
local keymap_query = ts.parse_query(
	'c',
	[[
(initializer_pair
    designator: (subscript_designator (identifier) @keymap_name) 
    value: (call_expression
             function: (identifier) @id (#eq? @id "LAYOUT_preonic_grid")
             arguments: (argument_list) @key_list))
]]
)

local key_query = ts.parse_query(
	'c',
	[[
(initializer_pair
    value: (call_expression
            arguments: (argument_list [(identifier) (call_expression)] @key)))
]]
)

-- take a layout, which is a list of keycodes
-- breaks into a table where each item represents a row (starting top left)
-- each row is a long string representation of the keys with even spacing adjusted columnwise
local function format_layout(options, layout)
	print 'hey'
	local width = options.columns

	assert(
		#layout % width == 0,
		"length of keys '" .. #layout .. "' is not divisible by keyboard width '" .. width .. "'"
	)

	-- table of key rows, starting at the top left
	local rows = { {} }
	local output = { '' }
	local current_row = 1
	local max_rows = #layout / width

	assert(max_rows == options.rows, 'rows be wrong' .. max_rows)

	-- split layout into rows
	for i, key in ipairs(layout) do
		assert(current_row <= max_rows, 'Too many rows ' .. i)
		table.insert(rows[current_row], key)

		-- end of row, so prepare the next
		if i % width == 0 then
			current_row = current_row + 1
			rows[current_row] = {}
		end
	end

	-- move through all rows at the same time by colum, padding width by longest key
	for col = 1, width do
		local longest_key = 1
		for row = 1, current_row - 1 do -- HACK from above increment in loop
			local key = rows[row][col]
			if #key > longest_key then longest_key = #key end
		end

		for row = 1, current_row - 1, 1 do -- HACK from abov
			local key = rows[row][col]
			if col == 1 then
				-- first column so no comma
				output[row] = '  ' .. key .. string.rep(' ', longest_key - #key)
			elseif col == width and row == max_rows then
				-- no trailing comma for last key
				output[row] = output[row] .. ' , ' .. key .. string.rep(' ', longest_key - #key)
			elseif col == width then
				-- last key so trailing comma
				output[row] = output[row] .. ' , ' .. key .. ','
			elseif col == width / 2 then
				-- show middle of keyboard
				output[row] = output[row]
					.. ' , '
					.. key
					.. string.rep(' ', longest_key - #key)
					.. ' /* | */'
			else
				output[row] = output[row] .. ' , ' .. key .. string.rep(' ', longest_key - #key)
			end
		end
	end

	return output
end

local function print_layout(layout) vim.pretty_print(layout) end

local function format_qmk_keymaps(options, buf)
	local bufnr = buf or vim.api.nvim_get_current_buf()
	local parser = ts.get_parser(bufnr, 'c')
	local root = parser:parse()[1]:root()

	for keymap_id, keymap_node in keymap_query:iter_captures(root, bufnr, 0, -1) do
		local capture_name = keymap_query.captures[keymap_id]

		-- if capture_name == "keymap_name" then
		-- 	local keymap_name = ts.get_node_text(keymap_node, bufnr)
		-- end

		if capture_name == 'key_list' then
			local start, _, final = keymap_node:range()
			local layout = {}

			for _, key_node in key_query:iter_captures(root, bufnr, start, final) do
				local key_txt = ts.get_node_text(key_node, bufnr)
				table.insert(layout, key_txt)
			end

			vim.api.nvim_buf_set_lines(
				bufnr,
				start + 1,
				final,
				false,
				format_layout(options, layout)
			)
			-- print_layout(layout)
			-- vim.api.nvim_buf_set_lines(bufnr, start + 1, final, false, print_layout(layout))
		end
	end
end

return format_qmk_keymaps
