local Seen = {}

function Seen:new()
	local me = { index = {} }
	self.__index = self
	return setmetatable(me, self)
end

function Seen:increment(cell, ctx)
	local seen = self.index[cell.key_index] or { span = 0 }
	self.index[cell.key_index] = {
		span = seen.span + cell.span,
		count = (seen.count or 0) + 1,
		is_last = not ctx.is_bridge_vert,
	}
end

function Seen:get(key_index)
	return self.index[key_index]
end

return Seen

---@class qmk.Seen
---@field new fun(): qmk.Seen
---@field increment fun(cell: qmk.LayoutGridCell, ctx: qmk.LayoutGridContext): nil
---@field get fun(key_index: number): qmk.SeenSpan | nil
---@field private index qmk.SeenIndex

---@alias qmk.SeenIndex table<number, qmk.SeenSpan>

---@class qmk.SeenSpan
---@field span number
---@field is_last boolean
---@field count number
