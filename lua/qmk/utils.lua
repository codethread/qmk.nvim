local M = {}

--generic Key : table
--param keymap Key[][]
--param fn fun(key: Key[]): nil

---crab along a keymap table (2d array), going from left to right, being passed each column to `fn`
---@generic Key : table
---@param keymap Key[][]
---@param fn fun(keys: Key[], column: number): nil
function M.crab(keymap, fn)
	local width = #keymap[1]
	local height = #keymap

	for col = 1, width do
		local column = {}
		for row = 1, height do
			table.insert(column, keymap[row][col])
		end
		fn(column, col)
	end
end

return M
