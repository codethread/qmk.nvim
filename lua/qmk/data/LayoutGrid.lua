---@diagnostic disable: invisible
local check = require('qmk.utils').check
local utils = require('qmk.utils')
local E = require('qmk.errors')

---comment
---@param key qmk.LayoutGridCell
---@param row qmk.LayoutGridCell[]
---@param i number
local function is_final_key(key, row, i)
	---@diagnostic disable-next-line: missing-parameter
	local keys = vim.list_slice(row, i + 1)

	for _, next_key in pairs(keys) do
		if next_key.type == 'key' then
			return false
		end
		if next_key.type == 'span' and next_key.key_index ~= key.key_index then
			return false
		end
	end
	return true
end

local function is_all_padding(ls)
	local padding = vim.tbl_filter(function(key)
		return key and (key.type == 'padding' or key.type == 'gap')
	end, ls)
	return #padding == #ls
end

---@type qmk.LayoutGridCell
local padding_cell = {
	key_index = 999999,
	type = 'padding',
	width = 1,
	key = ' ',
}

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
				if #key.key > longest_key then
					longest_key = #key.key
				end
			end
		end
		column_sizes[col] = longest_key
	end
	return column_sizes
end

---@class qmk.LayoutGrid
---@field new fun(self, layout: qmk.LayoutPlan, keys: string[]): qmk.LayoutGrid
---@field for_each fun(self, fn: fun(key: qmk.LayoutGridCell, context: qmk.LayoutGridContext): nil): nil
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
				table.insert(grid[row_i], {
					type = 'gap',
					key_index = 999999,
					width = 1,
					key = ' ',
				})
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

		-- add padding to start and end of row
		table.insert(grid[row_i], utils.shallow_copy(padding_cell))
		table.insert(grid[row_i], 1, utils.shallow_copy(padding_cell))
	end

	check(key_idx == #keys, E.config_mismatch)

	-- add padding to top and bottom of grid
	local padding_row = {}
	for _ = 1, #grid[1] do
		table.insert(padding_row, utils.shallow_copy(padding_cell))
	end
	table.insert(grid, utils.shallow_copy(padding_row))
	table.insert(grid, 1, utils.shallow_copy(padding_row))

	local largest_in_column = larget_per_column(grid)

	for row_i, row in pairs(grid) do
		for col_i, _ in pairs(row) do
			grid[row_i][col_i].span = largest_in_column[col_i]
		end
	end

	local me = { grid = grid }
	self.__index = self
	return setmetatable(me, self)
end

function LayoutGrid:cells()
	return self.grid
end

---@class qmk.LayoutGridContext
---@field col number
---@field row number
---@field is_empty boolean
---@field is_first boolean
---@field is_final_key boolean
---@field is_last boolean
---@field is_top boolean
---@field is_bottom boolean
---@field is_bridge_vert boolean
---@field is_bridge_down boolean
---@field is_sibling_bridge_down boolean
---@field is_sibling_bridge_vert boolean

function LayoutGrid:for_each(fn)
	for row_i, row in ipairs(self.grid) do
		local found_final_key = false

		for col_i, key in ipairs(row) do
			local key_index = key.key_index

			local is_top = row_i == 1
			local is_bottom = row_i == #self.grid
			local is_last = col_i == #row
			local is_first = col_i == 1

			local cell_right = not is_last and row[col_i + 1]
			local cell_down = not is_bottom and self.grid[row_i + 1] and self.grid[row_i + 1][col_i]
			local cell_down_right = not is_bottom
				and not is_last
				and self.grid[row_i + 1]
				and self.grid[row_i + 1][col_i + 1]

			---@type qmk.LayoutGridContext
			local ctx = {
				col = col_i,
				row = row_i,
				is_empty = is_all_padding({
					key,
					cell_right,
					cell_down,
					cell_down_right,
				}),
				is_bridge_vert = cell_right and key_index == cell_right.key_index,
				is_bridge_down = cell_down and key_index == cell_down.key_index,
				is_last = is_last,
				is_bottom = is_bottom,
				is_first = is_first,
				is_top = is_top,
				is_sibling_bridge_down = cell_right
					and cell_down_right
					and cell_right.key_index == cell_down_right.key_index,
				is_sibling_bridge_vert = cell_down
					and cell_down_right
					and cell_down.key_index == cell_down_right.key_index,
				is_final_key = not found_final_key and (is_last or is_final_key(key, row, col_i)),
			}

			fn(key, ctx)
		end
	end
end

return LayoutGrid

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.LayoutGridCell
---@field width number
---@field type 'key' | 'span' | 'gap' | 'padding'
---@field key string #the text value of the cell
---@field key_index number #the unique key id which is shared between different cells that represent the same physical key, e.g if the key spans two cells, each cell is stored in the grid, but will have the same key_index
---@field align? string
---@field span? number
