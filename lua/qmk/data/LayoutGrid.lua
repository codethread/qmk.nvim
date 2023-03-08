local E = require 'qmk.errors'

---@param grid qmk.LayoutGridCell[]
---@return number[]
local function larget_per_column(grid)
	local width = #grid[1]
	local height = #grid

	local column_sizes = {}
	for col = 1, width do
		local longest_key = 1
		for row = 1, height do
			local key = grid[row][col]
			if key.type == 'key' then
				if #key.key > longest_key then longest_key = #key.key end
			end
		end
		column_sizes[col] = longest_key
	end
	return column_sizes
end

---@class qmk.LayoutGrid
---@field new fun(self, layout: qmk.LayoutPlan, keys: string[]): qmk.LayoutGrid
---@field crab fun(self, fn: fun(keys: qmk.LayoutGridCell[], column: number): nil): nil
---@field cells fun(): qmk.LayoutGridCell[][]
---@field private grid qmk.LayoutGridCell[][]

---@type qmk.LayoutGrid
local LayoutGrid = {}

---@param layout qmk.LayoutPlan
---@param keys string[]
---@return qmk.LayoutGrid
function LayoutGrid:new(layout, keys)
	local key_idx = 0

	---@type qmk.LayoutGridCell[][]
	local grid = {}

	for row_i, row in pairs(layout) do
		grid[row_i] = {}
		for _, key in pairs(row) do
			if key.type == 'gap' then
				table.insert(grid[row_i], key)
			else
				key_idx = key_idx + 1
				for _ = 1, key.width do
					local info = vim.tbl_deep_extend('force', key, {
						key = keys[key_idx],
						key_index = key_idx,
					})
					table.insert(grid[row_i], info)
				end
			end
		end
	end

	assert(key_idx == #keys, E.config_mismatch)

	local largest_in_column = larget_per_column(grid)

	for _, row in pairs(grid) do
		for col_i, key in pairs(row) do
			key.span = largest_in_column[col_i]
		end
	end

	local me = { grid = grid }
	self.__index = self
	return setmetatable(me, self)
end

function LayoutGrid:crab(fn)
	local width = #self.grid[1]
	local height = #self.grid

	for col = 1, width do
		local column = {}
		for row = 1, height do
			table.insert(column, self.grid[row][col])
		end
		fn(column, col)
	end
end

function LayoutGrid:cells() return self.grid end

return LayoutGrid

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.LayoutGridCell
---@field width number
---@field align? string
---@field type 'key' | 'span' | 'gap'
---@field key string
---@field key_index number
---@field span? number
