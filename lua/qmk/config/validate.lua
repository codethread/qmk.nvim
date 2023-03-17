local utils = require('qmk.utils')
local E = require('qmk.errors')
local dic_validator = {
	position = function(position)
		local valid = { 'top', 'bottom', 'inside', 'none' }
		-- check if position is a valid value
		return vim.tbl_contains(valid, position), 'one of ' .. table.concat(valid, ', ')
	end,
}
local FIELD_OVERRIDE_TYPECHECK = {}

-- borrowed with love from nvim-tree
local function validate_options(user_config, default_config)
	local msg

	local function validate(user, def, prefix)
		-- only compare tables with contents that are not integer indexed
		if
			type(user) ~= 'table'
			or type(def) ~= 'table'
			or not next(def)
			or type(next(def)) == 'number'
		then
			return
		end

		for k, v in pairs(user) do
			local custom_validator = dic_validator[k]
			local invalid

			if custom_validator then
				local valid, valid_values = custom_validator(v)
				if not valid then
					invalid = E.parse_invalid(prefix, k, valid_values, v)
				end
			else
				local override_typecheck = FIELD_OVERRIDE_TYPECHECK[k] or {}
				if def[k] == nil then
					-- option does not exist
					invalid = E.parse_unknown(prefix, k)
				elseif type(v) ~= type(def[k]) and not override_typecheck[type(v)] then
					-- option is of the wrong type and is not a function
					invalid = E.parse_invalid(prefix, k, type(def[k]), type(v))
				end
			end

			if invalid then
				if msg then
					msg = string.format('%s | %s', msg, invalid)
				else
					msg = string.format('%s', invalid)
				end
				user[k] = nil
			else
				validate(v, def[k], prefix .. k .. '.')
			end
		end
	end

	validate(user_config, default_config, '')

	if msg then
		utils.die(E.parse_error_msg(msg))
	end
end

return validate_options
