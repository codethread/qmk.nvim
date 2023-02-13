local ts = vim.treesitter
local queries = require 'qmk.queries'
local E = require 'qmk.errors'

---@return qmk.Position
local function get_keymaps_position(root)
	local start, final
	local count = 0

	queries.declaration_visitor(root, {
		[queries.declaration_ids.declaration] = function(node)
			count = count + 1

			local row_start, _, row_end = node:range()
			start = row_start
			final = row_end
		end,
	})

	assert(count <= 1, E.keymaps_too_many)
	assert(count >= 1, E.keymaps_none)
	assert(start and final, E.keymaps_none)

	return { start = start, final = final }
end

---@return qmk.KeymapDict
local function get_keymaps(name, root, content)
	---@type qmk.KeymapDict
	local keymaps = {}
	---@type qmk.Keymap
	local current_keymap = {
		layout_name = name,
		keys = {},
	}
	local ids = queries.keymap_ids

	queries.keymap_visitor(name, root, {
		[ids.keymap_name] = function(node) --
			current_keymap.layer_name = ts.get_node_text(node, content)
		end,
		[ids.key_list] = function(node)
			local row_start, _, row_end = node:range()
			current_keymap.pos = { start = row_start, final = row_end }

			queries.key_visitor(root, {
				key = function(key_node)
					table.insert(current_keymap.keys, ts.get_node_text(key_node, content))
				end,
			}, content, row_start, row_end)
		end,
		[ids.final] = function(_)
			table.insert(keymaps, current_keymap)
			current_keymap = {
				layout_name = name,
				keys = {},
			}
		end,
	}, content)

	return keymaps
end

---get all keymaps from the current buffer
---@param content string
---@param options qmk.Config
---@return qmk.Keymaps
local function get_keymap(content, options)
	local parser = ts.get_string_parser(content, 'c', {})
	---@diagnostic disable-next-line: undefined-field
	local root = parser:parse()[1]:root()

	---@type qmk.Keymaps
	local info = {
		pos = get_keymaps_position(root),
		keymaps = get_keymaps(options.name, root, content),
	}

	return info
end

return get_keymap

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.Keymaps
---@field keymaps qmk.KeymapDict
---@field pos qmk.Position

---@alias qmk.KeymapDict { [string]: qmk.Keymap }

---@class qmk.Keymap
---@field layer_name string
---@field layout_name string
---@field keys string[]
---@field pos qmk.Position

---@class qmk.Position
---@field start number
---@field final number
