local parser = require('qmk.parse')
local api = vim.api

local for_hardware = {
	qmk = function(options, content, bufnr)
		local keymaps = parser.parse(table.concat(content, '\n'), options, parser.qmk)
		local formatted = require('qmk.format.qmk')(keymaps, options)
		api.nvim_buf_set_lines(bufnr, keymaps.pos.start + 1, keymaps.pos.final, false, formatted)
	end,
	zmk = function(options, content, bufnr)
		local keymaps = parser.parse(table.concat(content, '\n'), options, parser.zmk)
		local formatted = require('qmk.format.zmk')(keymaps, options)
		for _, keymap in ipairs(formatted) do
			api.nvim_buf_set_lines(
				bufnr,
				keymap.pos.start + 1,
				keymap.pos.final,
				false,
				keymap.keys
			)
		end
	end,
}

---format_qmk_keymaps
---@param options qmk.Config
---@param buf? number
local function format_qmk_keymaps(options, buf)
	local bufnr = buf or api.nvim_get_current_buf()
	local content = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for_hardware[options.variant](options, content, bufnr)
end

return format_qmk_keymaps
