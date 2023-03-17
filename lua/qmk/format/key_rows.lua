local utils = require('qmk.utils')
local Seen = require('qmk.data.Seen')
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
		return utils.center(span, key.key, space)
	end
end

---@param layout qmk.LayoutGrid
---@return string[]
local function print_rows(layout)
	local output = {}

	local comma = ' , '
	-- the final key won't have a comma, this allows it to be added in the rows
	-- later on (omitting the final row)
	local end_pad = ''

	local seen_keys = Seen:new()

	layout:for_each(function(key, ctx)
		local row = ctx.row

		if ctx.is_top or ctx.is_bottom then
			return
		end

		if ctx.is_first then
			output[row] = { '  ' }
		end

		local function add(str)
			table.insert(output[row], str)
		end
		local is_last = ctx.is_final_key

		if key.type == 'key' then
			add(key.key .. string.rep(space, key.span - #key.key))
			add(is_last and end_pad or comma)
		end

		if key.type == 'gap' then
			add(string.rep(space, key.span))
			add(string.rep(space, #comma))
		end

		if key.type == 'span' then
			seen_keys:increment(key, ctx)
			local seen = seen_keys:get(key.key_index)
			if seen and seen.is_last then
				-- normally every cell is padded by our 'comma' string
				-- so we need to account for that
				local seen_padding = (seen.count - 1) * #comma
				local full_span = seen.span + seen_padding

				add(align(full_span, key))
				add(is_last and end_pad or comma)
			end
		end
	end)

	local final = {}
	for i, row in pairs(output) do
		table.insert(final, table.concat(row) .. (i == #output and '' or ','))
	end
	return final
end

return print_rows
