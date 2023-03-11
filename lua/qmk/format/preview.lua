local utils = require 'qmk.utils'
local print = require 'qmk.format.print'

---@param layout qmk.LayoutGrid
---@param user_symbols table<string, string>
---@return string[][]
local function generate_old(layout, user_symbols)
	print.set_symbols(user_symbols)
	---@type qmk.LayoutGridCell[][]
	-- local layout = vim.tbl_map(function(row)
	-- 	return vim.tbl_filter(function(key) return key.type ~= 'padding' end, row)
	-- end, layout:cells())
	local layout = layout:cells()

	---@type string[][]
	local comment_rows = {}
	for index, _ in ipairs(layout) do
		comment_rows[(index * 2) - 1] = { '// ' }
		comment_rows[index * 2] = { '// ' }
	end
	comment_rows[#comment_rows + 1] = { '// ' }

	-- from left to right like a printer
	utils.crab(layout, function(column, col)
		local is_first = col == 1
		local is_last = col == #layout[1]
		local is_bridge = not is_first and layout[1][col].key_index == layout[1][col - 1].key_index
		local width = column[1].span + 2

		-- print the top comment row
		table.insert(
			comment_rows[1],
			is_first and print.tl(width)
				or is_last and print.tr(width)
				or is_bridge and print.tbridge(width)
				or print.tm(width)
		)

		for i, key in pairs(column) do
			-- want to print the current key and a comment beneath
			local row_idx = i * 2
			local key_text = key.type == 'gap' and ' ' or key.key -- TODO: sort out gap / space in config
			local remainder = key.span - #key_text
			local half = math.floor(remainder / 2)
			local centered = string.rep(' ', half) .. key_text .. string.rep(' ', half)
			local padding = string.rep(' ', key.span - string.len(centered))
			local text = ' ' .. centered .. padding .. ' '

			table.insert(
				comment_rows[row_idx],
				is_first and print.kl(text)
					or is_last and print.kr(text)
					or is_bridge and print.kbridge(text)
					or print.km(text)
			)

			local comment_idx = row_idx + 1
			-- bottom row
			if i == #column then
				table.insert(
					comment_rows[comment_idx],
					is_first and print.bl(width)
						or is_last and print.br(width)
						or is_bridge and print.bbridge(width)
						or print.bm(width)
				)
			else
				table.insert(
					comment_rows[comment_idx],
					is_first and print.ml(width)
						or is_last and print.mr(width)
						or is_bridge and print.mbridge(width)
						or print.mm(width)
				)
			end
		end
	end)

	return comment_rows
end

---@param layout qmk.LayoutGrid
---@param user_symbols table<string, string>
---@return string[][]
local function generate(layout, user_symbols)
	-- print.set_symbols(user_symbols)

	---@type string[][]
	local ouput = {}

	vim.pretty_print(layout:with_padding():cells())
	-- layout:for_each(function(cell, ctx)
	-- if ctx.is_bottom then return end
	-- if ctx.is_first then
	-- output
	-- end
	-- end)

	return output
end
return { generate = generate_old }
