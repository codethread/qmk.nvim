local utils = require 'qmk.utils'
local printer = require 'qmk.format.print'
local draw = require 'qmk.format.preview_key'

-- local symbols = {}

---comment
---@param width number
---@param key qmk.LayoutGridCell
---@param seen_key_index { span: number, is_last: boolean }[]
local function print_key(width, key, seen_key_index)
	if key.type == 'key' then
		local key_text = key.key
		local remainder = key.span - #key_text
		local half = math.floor(remainder / 2)
		local centered = string.rep(' ', half) .. key_text .. string.rep(' ', half)
		local padding = string.rep(' ', key.span - string.len(centered))
		local text = ' ' .. centered .. padding .. ' '
		return text
	end

	if key.type == 'span' then
		-- we keep track of how many times we've seen this key
		local seen = seen_key_index[key.key_index]
		if seen.is_last then
			-- we only print it if it aligns
			local key_text = key.key
			local remainder = seen.span - #key_text
			local half = math.floor(remainder / 2)
			local centered = string.rep(' ', half) .. key_text .. string.rep(' ', half)
			local padding = string.rep(' ', seen.span - string.len(centered))
			local text = ' ' .. centered .. padding .. '  '
			return text
		end
	end

	--- TEMP
	return printer.space(width)
end

local function print_border(width, key) return string.rep(key, width + 2) end

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

	-- i have so many regrets
	---@type { span: number, is_last: boolean }[]
	local seen_key_index = {}

	local function add_partial(ctx)
		return function(res)
			table.insert(comment_rows[(ctx.row * 2) - 1], res[1])
			table.insert(comment_rows[ctx.row * 2], res[2])
		end
	end

	layout:for_each(function(cell, ctx)
		if cell.type == 'span' then
			local seen = seen_key_index[cell.key_index] or { span = 0 }
			-- add up all the spacing found
			seen_key_index[cell.key_index] = {
				span = seen.span + cell.span,
				is_last = not ctx.is_bridge_vert,
			}
		end

		local add = function(res)
			return function() --
				-- if cell.type == 'span' then vim.pretty_print(cell) end
				add_partial(ctx)(res)
			end
		end
		local width = cell.span or 1

		utils.cond {
			-- ignore these are they are just padding
			{ ctx.is_bottom, 'do nothing' },
			{ ctx.is_last, 'do nothing' },

			-- handle special corners
			-- ┌─
			{
				ctx.is_bridge_vert and ctx.is_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.space,
					printer.space(width) .. symbols.tl,
				},
			},
			-- ─┐
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.space,
					print_border(width, symbols.horz) .. symbols.tr,
				},
			},
			-- ─┘
			{
				ctx.is_sibling_bridge_vert and ctx.is_sibling_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					print_border(width, symbols.horz) .. symbols.br,
				},
			},
			-- └─
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_vert,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					printer.space(width) .. symbols.bl,
				},
			},

			-- handle bridge cells
			-- ──
			-- ──
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_vert,
				add {
					print_key(width, cell, seen_key_index) .. symbols.space,
					print_border(width, symbols.horz) .. symbols.horz,
				},
			},
			-- ──
			-- --
			{
				ctx.is_bridge_vert,
				add {
					print_key(width, cell, seen_key_index) .. symbols.space,
					print_border(width, symbols.horz) .. symbols.tm,
				},
			},
			-- │ │
			-- │ │
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					printer.space(width) .. symbols.vert,
				},
			},
			-- │ |
			-- │ |
			{
				ctx.is_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					printer.space(width) .. symbols.ml,
				},
			},

			-- handle single cells
			-- -
			{
				ctx.is_sibling_bridge_vert,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					print_border(width, symbols.horz) .. symbols.bm,
				},
			},
			-- |
			{
				ctx.is_sibling_bridge_down,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					print_border(width, symbols.horz) .. symbols.mr,
				},
			},

			-- handle final case
			{
				true,
				add {
					print_key(width, cell, seen_key_index) .. symbols.vert,
					print_border(width, symbols.horz) .. symbols.mm,
				},
			},
		}
	end)

	local final = {}
	for index, row in ipairs(comment_rows) do
		if index > 1 and index < (#comment_rows - 1) then table.insert(final, row) end
	end
	return final
end
return { generate = generate }
