local M = {}

---@alias qmk.Seen { span: number, is_last: boolean, count: number }[]

---add up all the spacing found
---mutates seen in place
---@param cell qmk.LayoutGridCell
---@param ctx qmk.LayoutGridContext
---@param seen_key_index qmk.Seen
function M.increment_seen_span(cell, ctx, seen_key_index)
	local seen = seen_key_index[cell.key_index] or { span = 0 }
	seen_key_index[cell.key_index] = {
		span = seen.span + cell.span,
		count = (seen.count or 0) + 1,
		is_last = not ctx.is_bridge_vert,
	}
end

---@return qmk.Seen
function M.create_seen_key_index() return {} end

-- center a string within a span
function M.center(span, key_text, space)
	local remainder = span - #key_text
	local half = math.floor(remainder / 2)
	local centered = string.rep(space, half)
		.. key_text
		.. string.rep(space, half)
	local padding = string.rep(space, span - string.len(centered))
	local text = centered .. padding
	return text
end

return M
