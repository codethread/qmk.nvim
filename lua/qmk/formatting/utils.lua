local M = {}

---@param line string
---@return string
function M.remove_trailing_space(line)
	local trimmed = line:gsub(' +$', '')
	return trimmed
end

---@param line string
---@return string
function M.escape_magic_characters(line)
	-- Escape magic characters, but skip ones that are already escaped (backwards compatibility)
	local escaped = line:gsub('(%%?)([().%%+%-%*%?%[%]%^%$])', function(escape, char)
		return escape == '%' and escape .. char or '%' .. char
	end)
  return escaped
end

return M
