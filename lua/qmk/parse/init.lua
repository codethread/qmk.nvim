local E = require('qmk.errors')
local check = require('qmk.utils').check

local M = {
	qmk = require('qmk.parse.qmk'),
	zmk = require('qmk.parse.zmk'),
}

---assert all keymaps don't overlap with the declaration itself
---@param keymaps qmk.Keymaps
---@throws string
local function validate(keymaps)
	local start, final = keymaps.pos.start, keymaps.pos.final

	check(#keymaps.keymaps > 0, E.keymaps_none)

	-- iterate over all keymaps
	for _, keymap in pairs(keymaps.keymaps) do
		local keymap_start, keymap_final = keymap.pos.start, keymap.pos.final
		check(keymap_start > start, E.keymaps_overlap)
		check(keymap_final < final, E.keymaps_overlap)

		check(#keymap.keys > 0, E.keymap_empty(keymap.layer_name))
	end
end

---parse a keymap file, such as keymap.c for qmk into a qmk.Keymaps struct
---currenly only supports qmk keymaps, but in theory could support anything that parses to a qmk.Keymaps
---@param content string
---@param options qmk.Config
---@param parser fun(content: string, options: qmk.Config): qmk.Keymaps
---@return qmk.Keymaps
function M.parse(content, options, parser)
	local board_parser = parser
	local keymaps = board_parser(content, options)
	validate(keymaps)
	return keymaps
end

return M

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.Keymaps
---@field keymaps qmk.KeymapsList
---@field pos qmk.Position

---@alias qmk.KeymapsList qmk.Keymap[]

---@class qmk.Keymap
---@field layer_name string
---@field layout_name string
---@field keys string[]
---@field pos qmk.Position

---@class qmk.Position
---@field start number
---@field final number
