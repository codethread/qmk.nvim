---@type qmk.LayoutRow
local LayoutRow = {}

function LayoutRow:new(row, num_rows, num_cols)
	---@type qmk.LayoutRow
	local newObj = {
		_row = row,
		num_rows = num_rows,
		num_cols = num_cols,
	}
	self.__index = self
	return setmetatable(newObj, self)
end

function LayoutRow:for_row(fn)
	for _, key in pairs(self._row) do
		if key == 'x' then
			fn { key_type = 'simple' }
		else
			fn { key_type = 'space' }
		end
	end
end

---@type qmk.Layout
local Layout = {}

---@param layout qmk.UserLayout
function Layout:new(layout)
	local total_keys = 0
	for _, row in pairs(layout) do
		total_keys = total_keys + #row
	end

	---@type qmk.Layout
	local newObj = {
		_layout = layout,
		num_rows = #layout,
		num_cols = #layout[1],
		total_keys = total_keys,
	}
	self.__index = self
	return setmetatable(newObj, self)
end

function Layout:for_rows(fn)
	local layout = self._layout
	for _, row in pairs(layout) do
		fn(LayoutRow:new(row, self.num_rows, self.num_cols))
	end
end

return Layout

---@class qmk.Layout
---@field num_rows number
---@field num_cols number
---@field total_keys number
---@field for_rows fun(self, row: qmk.LayoutRow): nil
---@field new fun(self, layout: qmk.UserLayout): qmk.Layout
---@field private _layout qmk.UserLayout

---@class qmk.LayoutRow
---@field num_rows number
---@field num_cols number
---@field new fun(self, row: qmk.UserKey[], rows: number, cols: number): qmk.LayoutRow
---@field for_row fun(self, key: qmk.LayoutKey): nil
---@field private _row qmk.UserKey[]

---@class qmk.LayoutKey
---@field key_type 'simple' | 'space'
