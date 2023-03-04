local E = require 'qmk.errors'
---@alias qmk.KeymapList {key: string, value: string}[]

---@param key_map table<string, string>
---@return qmk.KeymapList
local function sort(key_map)
	---@type qmk.KeymapList
	local map = {}
	for key, value in pairs(key_map) do
		if type(key) ~= 'string' or type(value) ~= 'string' then
			error(E.config_keymap_invalid_pair(key, value))
		end
		table.insert(map, { key = key, value = value })
	end
	-- sort so that the longest key is at the top, meaning when we match up keys
	-- to the keymap, we'll get the most specific first, e.g
	-- KC_LEFT_CURLY_BRACE before KC_LEFT
	table.sort(map, function(a, b) return #a.key > #b.key end)
	return map
end

return sort
