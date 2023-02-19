local ts = vim.treesitter
local queries = require 'qmk.queries'
local E = require 'qmk.errors'

---assert all keymaps don't overlap with the declaration itself
---@param keymaps qmk.Keymaps
---@throws string
local function validate(keymaps)
	local start, final = keymaps.pos.start, keymaps.pos.final

	assert(#keymaps.keymaps > 0, E.keymaps_none)

	-- iterate over all keymaps
	for _, keymap in pairs(keymaps.keymaps) do
		local keymap_start, keymap_final = keymap.pos.start, keymap.pos.final
		assert(keymap_start > start, E.keymaps_overlap)
		assert(keymap_final < final, E.keymaps_overlap)

		assert(#keymap.keys > 0, E.keymap_empty(keymap.layer_name))
	end
end

---@return qmk.Position
local function get_keymaps_position(root)
	local start, final = nil, nil
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
	assert(start ~= final, E.keymaps_overlap)

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

	queries.keymap_visitor(name, root, content, {
		[ids.keymap_name] = function(node) --
			current_keymap.layer_name = ts.get_node_text(node, content)
		end,

		[ids.key_list] = function(node)
			local row_start, _, row_end = node:range()
			current_keymap.pos = { start = row_start, final = row_end }

			queries.key_visitor(node, {
				key = function(key_node)
					---@type string
					local key_text = ts.get_node_text(key_node, content)
					-- replace all newlines with a space in key_text
					local newlines_removed = key_text:gsub('%s', ''):gsub(',', ', ')
					if key_text ~= '' then table.insert(current_keymap.keys, newlines_removed) end
				end,
			})
		end,

		[ids.final] = function(_)
			table.insert(keymaps, current_keymap)
			current_keymap = {
				layout_name = name,
				keys = {},
			}
		end,
	})

	return keymaps
end

---get all keymaps from the current buffer
---@param content string
---@param options qmk.Config
---@return qmk.Keymaps
local function get_keymap(content, options)
	local parser = ts.get_string_parser(content, 'c', {})
	local root = parser:parse()[1]:root()

	---@type qmk.Keymaps
	local info = {
		pos = get_keymaps_position(root),
		keymaps = get_keymaps(options.name, root, content),
	}

	validate(info)

	return info
end

return get_keymap

--------------------------------------------------------------------------------
-- TYPES
--------------------------------------------------------------------------------

---@class qmk.Keymaps
---@field keymaps qmk.KeymapDict
---@field pos qmk.Position

---@alias qmk.KeymapDict { [string]: qmk.Keymap } # dictionary of keymaps

---@class qmk.Keymap
---@field layer_name string
---@field layout_name string
---@field keys string[]
---@field pos qmk.Position

---@class qmk.Position
---@field start number
---@field final number
