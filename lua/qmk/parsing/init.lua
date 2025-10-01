local E = require('qmk.errors')
local Utils = require('qmk.utils')
local merge_configs = require('qmk.config.merge')

local qmk_parser = require('qmk.qmk.parse')
local zmk_parser = require('qmk.zmk.parse')

local M = {
	qmk = qmk_parser.parse_keymaps,
	zmk = zmk_parser.parse_keymaps,
}

---assert all keymaps don't overlap with the declaration itself
---@param keymaps qmk.Keymaps
---@throws string
local function validate(keymaps)
	local start, final = keymaps.pos.start, keymaps.pos.final

	Utils.check(#keymaps.keymaps > 0, E.keymaps_none)

	-- iterate over all keymaps
	for _, keymap in pairs(keymaps.keymaps) do
		local keymap_start, keymap_final = keymap.pos.start, keymap.pos.final
		Utils.check(keymap_start > start, E.keymaps_overlap)
		Utils.check(keymap_final < final, E.keymaps_overlap)

		Utils.check(#keymap.keys > 0, E.keymap_empty(keymap.layer_name))
	end
end

---parse a keymap file, such as keymap.c for qmk into a qmk.Keymaps struct
---currenly only supports qmk keymaps, but in theory could support anything that parses to a qmk.Keymaps
---@param content string
---@param options qmk.Config
---@param parser fun(content: string, options: qmk.Config): qmk.Keymaps, qmk.InlineConfig | nil
---@return qmk.Keymaps, qmk.Config
function M.parse(content, options, parser)
	local keymaps, inline_config = parser(content, options)
	validate(keymaps)
	local final_config = inline_config and merge_configs.merge_configs(options, inline_config) or options

	return keymaps, final_config
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
