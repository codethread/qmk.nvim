local helper = require 'qmk.format.helper'
local space = ' '

---@param span number
---@param key qmk.LayoutGridCell
---@return string
local function align(span, key)
	-- alignment is a string like 1/3 or 2/3
	---@diagnostic disable-next-line: missing-parameter
	local ratio = vim.split(key.align, '/')
	local nom = tonumber(ratio[1])
	local denom = tonumber(ratio[2])

	if nom == 1 then
		-- left align
		return key.key .. string.rep(space, span - #key.key)
	elseif nom == denom then
		-- right align
		return string.rep(space, span - #key.key) .. key.key
	else
		-- center align
		return helper.center(span, key.key, space)
	end
end

---@param layout qmk.LayoutGrid
---@param spacing number
---@return string[]
local function print_rows(layout, spacing)
	local output = {}

	local comma = ' ,'
	local end_pad = string.rep(space, #comma)

	local seen_key_index = helper.create_seen_key_index()

	layout:for_each(function(key, ctx)
		local row = ctx.row

		if ctx.is_top or ctx.is_bottom then return end

		if ctx.is_first then output[row] = {} end

		local function add(str) table.insert(output[row], space .. str) end
		local is_last = ctx.is_final_key

		if key.type == 'span' then
			helper.increment_seen_span(key, ctx, seen_key_index)
			local seen = seen_key_index[key.key_index]
			if seen.is_last then
				-- normally every cell is padded by one whitespace and a single right border
				-- so we need to account for that
				local seen_padding = seen.count * 2
				--HACK what's going on wieht these numbers??
				-- now we know the full span of the key
				local full_span = seen.span + seen_padding - 1
				add(align(full_span, key) .. (is_last and end_pad or comma))
			end
		end

		if key.type == 'key' then
			add(key.key .. string.rep(space, key.span - #key.key) .. (is_last and end_pad or comma))
		end

		if key.type == 'gap' then add(string.rep(space, key.span) .. end_pad) end
	end)

	local final = {}
	for i, row in pairs(output) do
		table.insert(final, table.concat(row) .. (i == #output and '' or ','))
	end
	return final
end

return print_rows
