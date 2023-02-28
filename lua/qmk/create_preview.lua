local utils = require 'qmk.utils'

local symbols = {}

local function print_tl(width) return symbols.tl .. string.rep(symbols.div, width) end
local function print_tm(width) return symbols.tm .. string.rep(symbols.div, width) end
local function print_tr(width) return symbols.tm .. string.rep(symbols.div, width) .. symbols.tr end
local function print_tbridge(width) return symbols.div .. string.rep(symbols.div, width) end

local function print_bl(width) return symbols.bl .. string.rep(symbols.div, width) end
local function print_bm(width) return symbols.bm .. string.rep(symbols.div, width) end
local function print_br(width) return symbols.bm .. string.rep(symbols.div, width) .. symbols.br end
local function print_bbridge(width) return symbols.div .. string.rep(symbols.div, width) end

local function print_ml(width) return symbols.ml .. string.rep(symbols.div, width) end
local function print_mm(width) return symbols.mm .. string.rep(symbols.div, width) end
local function print_mr(width) return symbols.mm .. string.rep(symbols.div, width) .. symbols.mr end
local function print_mbridge(width) return symbols.div .. string.rep(symbols.div, width) end

local function print_kl(key) return symbols.sep .. key end
local function print_km(key) return symbols.sep .. key end
local function print_kr(key) return symbols.sep .. key .. symbols.sep end
local function print_kbridge(key) return symbols.sep .. key end

---@param layout_all qmk.LayoutKeyMapInfo[][]
---@param user_symbols table<string, string>
---@return string[][]
local function generate(layout_all, user_symbols)
	-- quick hack
	symbols = user_symbols
	---@type qmk.LayoutKeyMapInfo[][]
	local layout = vim.tbl_map(function(row)
		return vim.tbl_filter(function(key) return key.type ~= 'gap' end, row)
	end, layout_all)

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
			is_first and print_tl(width)
				or is_last and print_tr(width)
				or is_bridge and print_tbridge(width)
				or print_tm(width)
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
				is_first and print_kl(text)
					or is_last and print_kr(text)
					or is_bridge and print_kbridge(text)
					or print_km(text)
			)

			local comment_idx = row_idx + 1
			-- bottom row
			if i == #column then
				table.insert(
					comment_rows[comment_idx],
					is_first and print_bl(width)
						or is_last and print_br(width)
						or is_bridge and print_bbridge(width)
						or print_bm(width)
				)
			else
				table.insert(
					comment_rows[comment_idx],
					is_first and print_ml(width)
						or is_last and print_mr(width)
						or is_bridge and print_mbridge(width)
						or print_mm(width)
				)
			end
		end
	end)

	return comment_rows
end

return { generate = generate }
