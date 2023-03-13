local utils = require 'qmk.utils'
local printer = require 'qmk.format.print'

---@alias qmk.Seen { span: number, is_last: boolean, count: number }[]

-- local function center(span, key_text)
-- 	local remainder = span - #key_text
-- 	local half = math.floor(remainder / 2)
-- 	local centered = string.rep(space, half) .. key_text .. string.rep(space, half)
-- 	local padding = string.rep(space, span - string.len(centered))
-- 	local text = space .. centered .. padding .. space .. right_border
-- 	return text
-- end

-- add up all the spacing found
local function increment_seen_span(cell, ctx, seen_key_index)
	local seen = seen_key_index[cell.key_index] or { span = 0 }
	seen_key_index[cell.key_index] = {
		span = seen.span + cell.span,
		count = (seen.count or 0) + 1,
		is_last = not ctx.is_bridge_vert,
	}
end

---comment
---@param width number
---@param key qmk.LayoutGridCell
---@param seen_key_index qmk.Seen
---@param right_border string
local function print_key(width, key, seen_key_index, right_border)
	local space = ' '
	if key.type == 'key' then
		local key_text = key.key
		local remainder = key.span - #key_text
		local half = math.floor(remainder / 2)
		local centered = string.rep(space, half) .. key_text .. string.rep(space, half)
		local padding = string.rep(space, key.span - string.len(centered))
		local text = space .. centered .. padding .. space .. right_border
		return text
	end

	if key.type == 'span' then
		-- we keep track of how many times we've seen this key
		-- and print it the final time, now that we know the full width it will consume
		local seen = seen_key_index[key.key_index]
		if seen.is_last then
			-- normally every cell is padded by one whitespace and a single right border
			-- so we need to account for that
			local seen_padding = seen.count * 3
			-- now we know the full width of the key, but we also remove one to allow us
			-- to add our own right border
			local full_width = seen.span + seen_padding - 1

			local key_text = key.key
			local remainder = full_width - #key_text
			local half = math.floor(remainder / 2)
			local centered = string.rep(space, half) .. key_text .. string.rep(space, half)
			local padding = string.rep(space, full_width - string.len(centered))
			local text = centered .. padding .. right_border
			return text
		else
			return ''
		end
	end

	if key.type == 'padding' then return printer.space(width) .. right_border end
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

	---@type qmk.Seen
	local seen_key_index = {}

	local function add_partial(ctx)
		return function(res)
			table.insert(comment_rows[(ctx.row * 2) - 1], res[1])
			table.insert(comment_rows[ctx.row * 2], res[2])
		end
	end

	layout:for_each(function(cell, ctx)
		if cell.type == 'span' then increment_seen_span(cell, ctx, seen_key_index) end

		local add = function(res) add_partial(ctx)(res) end
		local width = cell.span or 1

		utils.cond {
			-- ignore these are they are just padding
			{ ctx.is_bottom, 'do nothing' },
			{ ctx.is_last, 'do nothing' },

			-- handle special corners
			-- ┌─
			{
				ctx.is_bridge_vert and ctx.is_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.space),
						printer.space(width) .. symbols.tl,
					}
				end,
			},
			-- ─┐
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.space),
						print_border(width, symbols.horz) .. symbols.tr,
					}
				end,
			},
			-- ─┘
			{
				ctx.is_sibling_bridge_vert and ctx.is_sibling_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						print_border(width, symbols.horz) .. symbols.br,
					}
				end,
			},
			-- └─
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_vert,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						printer.space(width) .. symbols.bl,
					}
				end,
			},

			-- handle bridge cells
			-- ──
			-- ──
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_vert,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.space),
						print_border(width, symbols.horz) .. symbols.horz,
					}
				end,
			},
			-- ──
			-- --
			{
				ctx.is_bridge_vert,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.space),
						print_border(width, symbols.horz) .. symbols.tm,
					}
				end,
			},
			-- │ │
			-- │ │
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						printer.space(width) .. symbols.vert,
					}
				end,
			},
			-- │ |
			-- │ |
			{
				ctx.is_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						printer.space(width) .. symbols.ml,
					}
				end,
			},

			-- handle single cells
			-- -
			{
				ctx.is_sibling_bridge_vert,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						print_border(width, symbols.horz) .. symbols.bm,
					}
				end,
			},
			-- |
			{
				ctx.is_sibling_bridge_down,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						print_border(width, symbols.horz) .. symbols.mr,
					}
				end,
			},

			-- handle final case
			{
				true,
				function()
					add {
						print_key(width, cell, seen_key_index, symbols.vert),
						print_border(width, symbols.horz) .. symbols.mm,
					}
				end,
			},
		}
	end)

	local final = {}
	-- trim off padding
	for index, row in ipairs(comment_rows) do
		if index > 1 and index < (#comment_rows - 1) then table.insert(final, row) end
	end
	return final
end
return { generate = generate }
