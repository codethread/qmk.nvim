local M = {}

---@param line string
---@return string
function M.remove_trailing_space(line)
	local trimed = line:gsub(' +$', '')
	return trimed
end

return M
