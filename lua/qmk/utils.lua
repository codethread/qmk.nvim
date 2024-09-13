local M = {}

---stop execution with an error message, without stack trace
---users don't care about my stack traces, they just want to know what's wrong
function M.die(msg)
	error(msg, 0)
end

function M.check(cond, msg)
	if not cond then
		M.die(msg)
	end
end

M.timeout = 0

function M.notify(err)
	vim.notify(err, vim.log.levels.ERROR, { title = 'qmk.nvim', timeout = M.timeout })
end

function M.cond(conditions)
	for _, v in ipairs(conditions) do
		local predicate = v[1]
		local result = v[2]
		if type(predicate) == 'function' and predicate() or predicate then
			return type(result) == 'function' and result() or result
		end
	end
	error('no condition matched')
end

function M.shallow_copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

function M.len(str)
	return vim.fn.strdisplaywidth(str)
end

-- center a string within a span
function M.center(span, text, space_symbol)
	local remainder = span - M.len(text)
	local half = math.floor(remainder / 2)
	local centered = string.rep(space_symbol, half) .. text .. string.rep(space_symbol, half)
	local padding = string.rep(space_symbol, span - M.len(centered))
	return centered .. padding
end

---Remove all `false`s from an iterator, expected in `vim.iter():filter()`
---@param item any
---@return boolean
function M.remove_false(item)
	return not not item
end

return M
