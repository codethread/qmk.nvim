local printer = require 'qmk.format.print'
local draw = {}

---@alias Drawer fun(user_symbols: qmk.PreviewSymbols, cell: qmk.LayoutGridCell, ctx: qmk.LayoutGridContext): string[]

---@type Drawer
function draw.top_left(symbols, cell, ctx)
	local width = cell.span

	return {
		printer.space(width),
		printer.tl(width),
	}
end

---@type Drawer
function draw.empty(symbols, cell, ctx)
	local width = cell.span

	return {
		printer.space(width) .. symbols.space,
		printer.space(width) .. symbols.space,
	}
end

---@type Drawer
function draw.bridge_vert(symbols, cell, ctx)
	local width = cell.span

	-- start simple and draw the key each time
	return {
		printer.space(width),
		string.rep(symbols.horz, width) .. symbols.horz,
	}
end

---@type Drawer
function draw.sibling_bridge_vert(symbols, cell, ctx)
	local width = cell.span

	-- start simple and draw the key each time
	return {
		printer.space(width) .. symbols.vert,
		string.rep(symbols.horz, width) .. symbols.bm,
	}
end

---@type Drawer
function draw.bottom_right(symbols, cell, ctx)
	local width = cell.span

	-- start simple and draw the key each time
	return {
		printer.space(width) .. symbols.vert,
		string.rep(symbols.horz, width) .. symbols.br,
	}
end

return draw
