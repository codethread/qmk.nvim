---@alias qmk.KeymapList {key: string, value: string}[]

---@param key_map table<string, string>
---@return qmk.KeymapList
local function sort(key_map)
	---@type qmk.KeymapList
	local map = {}
	for key, value in pairs(key_map) do
		-- print('key_map', vim.inspect { key = key, value = value })
		if type(key) ~= 'string' or type(value) ~= 'string' then
			error(
				'keymap_overrides must be a dictionary of string keys and values, invalid: { '
						.. key
					or 'nil' .. '=' .. value
					or 'nil' .. ' }'
			)
		end
		table.insert(map, { key = key, value = value })
	end
	table.sort(map, function(a, b) return #a.key > #b.key end)
	return map
end

return sort
