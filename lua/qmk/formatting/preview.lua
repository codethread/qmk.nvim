local E = require('qmk.errors')
local Seen = require('qmk.data.Seen')
local utils = require('qmk.utils')

local space = ' '

local function print_space(span, right_border)
	return ' ' .. string.rep(space, span) .. ' ' .. right_border
end

---@param span number
---@param key qmk.LayoutGridCell
---@param seen_keys qmk.Seen
---@param right_border string
local function print_key(span, key, seen_keys, right_border)
	if key.type == 'key' then
		local centered = utils.center(key.span, key.key, space)
		local text = space .. centered .. space .. right_border
		return text
	end

	if key.type == 'gap' then
		return print_space(span, right_border)
	end

	if key.type == 'span' then
		-- we keep track of how many times we've seen this key
		-- and print it the final time, now that we know the full span it will consume
		local seen = seen_keys:get(key.key_index)
		if seen and seen.is_last then
			-- normally every cell is padded by one whitespace and a single right border
			-- so we need to account for that
			local seen_padding = seen.count * 3
			-- now we know the full span of the key, but we also remove one to allow us
			-- to add our own right border
			local full_span = seen.span + seen_padding - 1

			local centered = utils.center(full_span, key.key, space)
			local text = centered .. right_border
			return text
		else
			return ''
		end
	end

	if key.type == 'padding' then
		return print_space(span, right_border)
	end
end

local function print_border(span, key, right_border)
	return string.rep(key, span + 2) .. right_border
end

--Generate a preview of the layout
--padding cells are used to create a consistent heuristic around the whole board
--meaning all keys can just look at the keys to their right, beneath and bottom right.
--they then render themselves and their right and bottom walls
--
--Alignment is ignored and always just centered
--I also assume two individual keys will be wider than a single key spanning two rows
--for the sake of simplicity
---@param layout qmk.LayoutGrid
---@param user_symbols table<string, string>
---@return string[][]
local function generate(layout, user_symbols)
	local symbols = user_symbols

	---@type string[][]
	local comment_rows = {}
	for index, _ in ipairs(layout:cells()) do
		comment_rows[(index * 2) - 1] = { '// ' }
		comment_rows[index * 2] = { '// ' }
	end

	local seen_keys = Seen:new()

	layout:for_each(function(cell, ctx)
		if cell.type == 'span' then
			seen_keys:increment(cell, ctx)
		end

		---update the comment rows with each new cell
		---@param cell_tuple string[] #a tuple of strings representing the current cell and it's bottom border
		local function update(cell_tuple)
			table.insert(comment_rows[(ctx.row * 2) - 1], cell_tuple[1])
			table.insert(comment_rows[ctx.row * 2], cell_tuple[2])
		end

		local span = cell.span or 1

		utils.cond({
			-- ignore these are they are just padding
			{ ctx.is_bottom, 'do nothing' },
			{ ctx.is_last, 'do nothing' },

			{
				ctx.is_empty,
				function()
					update({
						print_space(span, symbols.space),
						print_space(span, symbols.space),
					})
				end,
			},

			--------------------------------------------------------------------------
			-- handle special corners
			--------------------------------------------------------------------------
			-- ┌─
			{
				ctx.is_bridge_vert and ctx.is_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.space),
						print_space(span, symbols.tl),
					})
				end,
			},
			-- ─┐
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.space),
						print_border(span, symbols.horz, symbols.tr),
					})
				end,
			},
			-- ─┘
			{
				ctx.is_sibling_bridge_vert and ctx.is_sibling_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_border(span, symbols.horz, symbols.br),
					})
				end,
			},
			-- └─
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_vert,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_space(span, symbols.bl),
					})
				end,
			},

			--------------------------------------------------------------------------
			-- handle bridge cells
			--------------------------------------------------------------------------
			-- ──
			-- ──
			{
				ctx.is_bridge_vert and ctx.is_sibling_bridge_vert,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.space),
						print_border(span, symbols.horz, symbols.horz),
					})
				end,
			},
			-- ──
			-- --
			{
				ctx.is_bridge_vert,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.space),
						print_border(span, symbols.horz, symbols.tm),
					})
				end,
			},
			-- │ │
			-- │ │
			{
				ctx.is_bridge_down and ctx.is_sibling_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_space(span, symbols.vert),
					})
				end,
			},
			-- │ |
			-- │ |
			{
				ctx.is_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_space(span, symbols.ml),
					})
				end,
			},

			--------------------------------------------------------------------------
			-- handle single cells
			--------------------------------------------------------------------------
			-- -
			{
				ctx.is_sibling_bridge_vert,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_border(span, symbols.horz, symbols.bm),
					})
				end,
			},
			-- |
			{
				ctx.is_sibling_bridge_down,
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_border(span, symbols.horz, symbols.mr),
					})
				end,
			},

			-- ..
			-- ..
			{
				not (
						ctx.is_sibling_bridge_vert
						or ctx.is_sibling_bridge_down
						or ctx.is_bridge_vert
						or ctx.is_bridge_down
					),
				function()
					update({
						print_key(span, cell, seen_keys, symbols.vert),
						print_border(span, symbols.horz, symbols.mm),
					})
				end,
			},

			--------------------------------------------------------------------------
			-- unexpected
			--------------------------------------------------------------------------
			{
				true,
				function()
					vim.notify(E.dev_error)
					update({
						print_space(span, symbols.vert),
						print_space(span, symbols.vert),
					})
				end,
			},
		})
	end)

	local final = {}
	-- trim off padding
	for index, row in ipairs(comment_rows) do
		if index > 1 and index < (#comment_rows - 1) then
			local done = false
			local trimmed = vim
				.iter(row)
				-- double reverse so we can filter out whitespace starting from the end
				:rev()
				:filter(function(key)
					-- just whitespace
					if not done and key:match('^%s+$') then
						return false
					else
						done = true
						return true
					end
				end)
				:rev()
				:totable()
			table.insert(final, trimmed)
		end
	end
	return final
end
return { generate = generate }
