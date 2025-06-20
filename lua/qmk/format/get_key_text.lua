local utils = require('qmk.format.utils')

---find all matching key codes from the key string and replace them with the keymap value
---@param keymap qmk.KeymapList
---@return fun (key : string): string
local function get_key_text(keymap)
	return function(str)
		for _, k in ipairs(keymap) do
      -- escape lua magic characters in the matching pattern
      local key, value = utils.escape_magic_characters(k.key), k.value
			-- check if the key is a substring of the current key
			if string.find(str, key) then
				-- replace the key with the override
				str = string.gsub(str, key, value)
			end
		end
		return str
	end
end

return get_key_text
