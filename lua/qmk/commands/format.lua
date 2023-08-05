local parser = require('qmk.parse')
local api = vim.api

local function qmk(options, content, bufnr)
	local keymaps, config = parser.parse(table.concat(content, '\n'), options, parser.qmk)
	local formatted = require('qmk.format.qmk')(keymaps, config)
	api.nvim_buf_set_lines(bufnr, keymaps.pos.start + 1, keymaps.pos.final, false, formatted)
end

local function zmk(options, content, bufnr, last_keymap)
	local keymap_id = last_keymap or 1
	local keymaps = parser.parse(table.concat(content, '\n'), options, parser.zmk).keymaps

	local keymap = keymaps[keymap_id]
	if keymap ~= nil then
		local out = require('qmk.format.zmk')(keymap, options)
		vim.list_extend(out.preview, out.keys)
		api.nvim_buf_set_lines(bufnr, out.pos.start + 1, out.pos.final, false, out.preview)

		-- we just reparse over and over till all keymaps are done
		local new_content = api.nvim_buf_get_lines(bufnr, 0, -1, false)
		zmk(options, new_content, bufnr, keymap_id + 1)
	end
end

local for_hardware = {
	qmk = qmk,
	zmk = zmk,
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
