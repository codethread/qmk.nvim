local queries = require('qmk.parse.zmk.queries')
local ts = vim.treesitter

---@return qmk.Keymap
local function empty_keymap()
	return {
		layout_name = 'ZMK', -- doesn't matter
		keys = {},
	}
end

local function join(list)
	return table.concat(list, ' ')
end

---@return qmk.KeymapDict
local function get_keymaps(root, content)
	---@type qmk.KeymapDict
	local keymaps = {}

	local current_keymap = empty_keymap()
	local keys = {}

	local ids = queries.keymap_ids

	queries.keymap_visitor(root, content, {
		[ids.layer_name] = function(node)
			current_keymap.layer_name = ts.get_node_text(node, content)
		end,

		[ids.bindings] = function(node)
			current_keymap.pos = {
				start = node:start(),
				final = node:end_(),
			}

			for child in node:iter_children() do
				if child:named() then
					local text = (ts.get_node_text(child, content))

					if child:type() == 'reference' or vim.startswith(text, '_') then
						vim.list_extend(keys, { { text } })
					else
						vim.list_extend(keys[#keys], { text })
					end
				end
			end
		end,

		[ids.final] = function()
			current_keymap.keys = vim.tbl_map(join, keys)
			table.insert(keymaps, current_keymap)
			keys = {}
			current_keymap = empty_keymap()
		end,
	})

	return keymaps
end

---get all keymaps from the current buffer
---@param content string
---@param options qmk.Config
---@return qmk.Keymaps
local function get_keymap(content, options)
	local parser = ts.get_string_parser(content, 'devicetree', {})
	local root = parser:parse()[1]:root()

	return {
		pos = { start = 0, final = 10000000 },
		keymaps = get_keymaps(root, content),
	}
end

return get_keymap
