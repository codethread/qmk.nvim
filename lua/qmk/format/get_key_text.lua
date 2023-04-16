---find all matching key codes from the key string and replace them with the keymap value
---@param keymap qmk.KeymapList
---@return fun (key : string): string
local function get_key_text(keymap)
	return function(key)
		local str = key
		for _, k in ipairs(keymap) do
			-- check if the key is a substring of the current key
			if string.find(str, k.key) then
				-- replace the key with the override
				str = string.gsub(str, k.key, k.value)
			end
		end
		return str
	end
end

return get_key_text
