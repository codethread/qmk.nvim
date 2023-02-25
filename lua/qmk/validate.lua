local FIELD_SKIP_VALIDATE = {}
local FIELD_OVERRIDE_TYPECHECK = {}

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
			if not FIELD_SKIP_VALIDATE[k] then
				local invalid
				local override_typecheck = FIELD_OVERRIDE_TYPECHECK[k] or {}
				if def[k] == nil then
					-- option does not exist
					invalid = string.format('[QMK] unknown option: %s%s', prefix, k)
				elseif type(v) ~= type(def[k]) and not override_typecheck[type(v)] then
					-- option is of the wrong type and is not a function
					invalid = string.format(
						'[QMK] invalid option: %s%s expected: %s actual: %s',
						prefix,
						k,
						type(def[k]),
						type(v)
					)
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
	end

	validate(user_config, default_config, '')

	if msg then
		vim.notify_once(
			msg .. ' | see :help qmk-setup for available configuration options',
			vim.log.levels.WARN
		)
	end
end

return validate_options
