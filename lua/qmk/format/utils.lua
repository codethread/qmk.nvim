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

---@param options qmk.Config
---@return string
function M.get_indent_string(options)
	if not options.indentation.enabled then
		return ''
	end

	local indent_char = ' '
	local indent_string = ''

	for _ = 1, options.indentation.width, 1 do
		indent_string = indent_char .. indent_string
	end

	return indent_string
end

return M
