local utils = require 'qmk.utils'
local printer = require 'qmk.format.print'
local draw = require 'qmk.format.preview_key'

-- local symbols = {}

---@param layout qmk.LayoutGrid
---@param user_symbols table<string, string>
---@return string[][]
local function generate_old(layout, user_symbols)
	printer.set_symbols(user_symbols)
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
			is_first and printer.tl(width)
				or is_last and printer.tr(width)
				or is_bridge and printer.tbridge(width)
				or printer.tm(width)
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
				is_first and printer.kl(text)
					or is_last and printer.kr(text)
					or is_bridge and printer.kbridge(text)
					or printer.km(text)
			)

			local comment_idx = row_idx + 1
			-- bottom row
			if i == #column then
				table.insert(
					comment_rows[comment_idx],
					is_first and printer.bl(width)
						or is_last and printer.br(width)
						or is_bridge and printer.bbridge(width)
						or printer.bm(width)
				)
			else
				table.insert(
					comment_rows[comment_idx],
					is_first and printer.ml(width)
						or is_last and printer.mr(width)
						or is_bridge and printer.mbridge(width)
						or printer.mm(width)
				)
			end
		end
	end)

	return comment_rows
end

--Generate a preview of the layout
--padding cells are used to create a consistent heuristic around the whole board
--meaning all keys can just look at the keys to their right, beneath and bottom right.
--they then render themselves and their right and bottom walls
--the padding keeps this consistent, but I do need to remember not to draw them
--alignment is ignored and always just centered
--I also assume two individual keys will be wider than a single key spanning two rows
--for the sake of simplicity
--
--also now thinking, draw the grid in once pass,
--then on a second pass, insert the keys directly onto the 'canvas'
---@param layout qmk.LayoutGrid
---@param user_symbols table<string, string>
---@return string[][]
local function generate(layout, user_symbols)
	printer.set_symbols(user_symbols)
	local symbols = user_symbols

	---@type string[][]
	local comment_rows = {}
	for index, _ in ipairs(layout:cells()) do
		comment_rows[(index * 2) - 1] = { '// ' }
		comment_rows[index * 2] = { '// ' }
	end
	-- comment_rows[#comment_rows + 1] = { '// ' }

	local function add_partial(ctx)
		return function(res)
			table.insert(comment_rows[(ctx.row * 2) - 1], res[1])
			table.insert(comment_rows[ctx.row * 2], res[2])
		end
	end

	local function use_partial(cell, ctx)
		return function(fn)
			return function()
				local res = fn(user_symbols, cell, ctx)
				add_partial(ctx)(res)
			end
		end
	end

	layout:for_each(function(cell, ctx)
		local use = use_partial(cell, ctx)
		local add = function(res)
			return function() add_partial(ctx)(res) end
		end
		local width = cell.span or 1
		print(cell.key, cell.type, ctx.is_sibling_bridge_vert)

		utils.cond {
			-- ignore these are they are just padding
			{ ctx.is_bottom, 'do nothing' },
			{ ctx.is_last, 'do nothing' },

			-- handle special corners
			-- ┌─
			{
				ctx.is_bridge_vert and ctx.is_bridge_down,
				add {
					printer.space(width) .. symbols.space,
					printer.space(width) .. symbols.tl,
				},
			},
			-- ─┐
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_down,
				add {
					printer.space(width) .. symbols.space,
					string.rep(symbols.horz, width) .. symbols.tr,
				},
			},
			-- ─┘
			{
				ctx.is_sibling_bridge_vert and ctx.is_sibling_bridge_down,
				add {
					printer.space(width) .. symbols.vert,
					string.rep(symbols.horz, width) .. symbols.br,
				},
			},
			-- └─
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_vert,
				add {
					printer.space(width) .. symbols.vert,
					printer.space(width) .. symbols.bl,
				},
			},

			-- handle bridge cells
			-- ──
			-- ──
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_vert,
				add {
					printer.space(width) .. symbols.space,
					string.rep(symbols.horz, width) .. symbols.horz,
				},
			},
			-- ──
			-- --
			{
				ctx.is_bridge_vert,
				add {
					printer.space(width) .. symbols.space,
					string.rep(symbols.horz, width) .. symbols.tm,
				},
			},
			-- │ │
			-- │ │
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_down,
				add {
					printer.space(width) .. symbols.vert,
					printer.space(width) .. symbols.vert,
				},
			},
			-- │ |
			-- │ |
			{
				ctx.is_bridge_down,
				add {
					printer.space(width) .. symbols.vert,
					printer.space(width) .. symbols.ml,
				},
			},

			-- handle single cells
			-- -
			{
				ctx.is_sibling_bridge_vert,
				add {
					printer.space(width) .. symbols.vert,
					string.rep(symbols.horz, width) .. symbols.bm,
				},
			},
			-- |
			{
				ctx.is_sibling_bridge_down,
				add {
					printer.space(width) .. symbols.vert,
					string.rep(symbols.horz, width) .. symbols.mr,
				},
			},
			-- else
			-- {
			-- 	true,
			-- 	add {
			-- 		printer.space(width) .. symbols.vert,
			-- 		string.rep(symbols.horz, width) .. symbols.mm,
			-- 	},
			-- },

			-- { true, use(draw.empty) },
		}
	end)

	vim.pretty_print(comment_rows)

	return comment_rows
end
return { generate = generate }
