local M = {}

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

---stop execution with an error message, without stack trace
---users don't care about stack traces, they just want to know what's wrong
function M.die(msg) error(msg, 0) end

function M.assert(cond, msg)
	if not cond then M.die(msg) end
end

return M
