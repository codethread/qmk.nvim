local parse = require('qmk.parse').parse
local format = require('qmk.format.keymaps')
local api = vim.api

---format_qmk_keymaps
---@param options qmk.Config
---@param buf? number
local function format_qmk_keymaps(options, buf)
	local bufnr = buf or api.nvim_get_current_buf()
	local content = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local keymaps = parse(table.concat(content, '\n'), options)
	local formatted = format(keymaps, options)
	api.nvim_buf_set_lines(bufnr, keymaps.pos.start + 1, keymaps.pos.final, false, formatted)
end

return format_qmk_keymaps
