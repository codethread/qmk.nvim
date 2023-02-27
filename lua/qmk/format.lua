local get_keymaps = require 'qmk.get_keymaps'
local format_keymaps = require 'qmk.format_keymaps'
local api = vim.api

local function print_layout(layout) vim.pretty_print(layout) end

---format_qmk_keymaps
---@param options qmk.Config
---@param buf? number
local function format_qmk_keymaps(options, buf)
	local bufnr = buf or api.nvim_get_current_buf()
	local content = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local keymaps = get_keymaps(table.concat(content, '\n'), options)
	local formatted = format_keymaps(keymaps, options)
	api.nvim_buf_set_lines(bufnr, keymaps.pos.start + 1, keymaps.pos.final, false, formatted)
end

return format_qmk_keymaps
