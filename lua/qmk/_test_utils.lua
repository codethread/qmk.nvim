local config = require('qmk.config')
local Path = require('plenary.path')

local M = {}

---compare two files by reading `input` into a buffer (which is returned to the caller for manipulation)
---the buffer content can then be retrieved via `buff_content` (at which point the output will also
---be written to `input`_actual for comparison)
---@param input string #name of the file, the expected result must be of the same filename appended with '_out'
---@param fixture_dir? string #directory to look in, defaults to 'qmk'
---@return { expected: string[], buff: number, buff_content: fun(): string[] }
function M.snapshot(input, fixture_dir)
	local dir = fixture_dir or 'qmk'
	local parts = vim.split(input, '.', { plain = true })
	local filename = parts[1]
	local extension = '.' .. parts[2]

	local content = Path:new('test', 'fixtures', dir, input):read()
	local out = Path:new('test', 'fixtures', dir, filename .. '_out' .. extension):read()
	local actual = Path:new('test', 'fixtures', dir, filename .. '_actual' .. extension)

	local buff = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buff, 0, -1, false, vim.split(content, '\n', {}))

	return {
		-- expected text as list of lines
		expected = vim.split(out, '\n', {}),
		-- buffer handle
		buff = buff,
		-- function to get buffer content as list of lines
		buff_content = function()
			local buff_content = vim.api.nvim_buf_get_lines(buff, 0, -1, false)
			actual:write(table.concat(buff_content, '\n'), 'w')
			return buff_content
		end,
	}
end

---@param layout qmk.UserLayout
---@param variant? string
---@return qmk.Config
function M.create_options(layout, variant)
	return config.parse({
		name = 'test',
		comment_preview = { position = 'none' },
		layout = layout,
		variant = variant or 'qmk',
	})
end

---@param layout qmk.UserLayout
---@param options? qmk.UserConfig
---@return qmk.Config
function M.create_options_preview(layout, options)
	return config.parse(vim.tbl_deep_extend('force', {
		name = 'test',
		layout = layout,
		comment_preview = { position = 'top' },
	}, options or {}))
end

return M
