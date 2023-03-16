local E = {
	keymaps_none = 'QMK: [E01] No keymaps found',
	keymaps_too_many = 'QMK: [E02] Found more than one keymap declaration',
	keymaps_overlap = 'QMK: [E03] One ore more keymap declarations overlap with the start and or end of the keymaps "const" declaration',
	keymap_empty = function(name)
		return 'QMK: [E04] No keys found in keymap ' .. name
	end,

	config_missing = 'QMK: [E08] user_config is required for setup()',
	config_missing_required = 'QMK: [E09] config missing, required keys are name & layout',
	config_keymap_invalid_pair = function(key, value)
		return (
			'QMK: [E10] keymap_overrides must be a dictionary of string keys and values, invalid: { '
				.. key
			or 'nil' .. '=' .. value
			or 'nil' .. ' }'
		)
	end,

	config_mismatch = 'QMK: [E05] no enough keys for layout',
	config_invalid_symbol = 'QMK: [E06] invalid layout, expected "x", "_" or "^"',
	config_invalid_span = 'QMK: [E07] invalid layout, expected a ^ in the key',
	layout_empty = 'QMK: [E15] layout is empty',
	layout_row_empty = 'QMK: [E15] layout.row is empty',
	layout_trailing_whitespace = 'QMK: [E11] layout starts or ends with whitespace, use a break "_" or span "x^" to create spaces',
	layout_double_whitespace = 'QMK: [E12] layout contains two or more adjacent spaces, use a break "_" or span "x^" to create spaces',

	parse_unknown = function(prefix, option)
		return 'QMK: [E13] '
			.. string.format('unknown option: %s%s', prefix, option)
	end,
	parse_invalid = function(prefix, option, expected, got)
		return 'QMK: [E14] '
			.. string.format(
				'invalid option: "%s%s", expected: %s, got: %s',
				prefix,
				option,
				expected,
				got
			)
	end,
	parse_error_msg = function(msg)
		return msg
			.. ' | see :help qmk-setup for available configuration options'
	end,

	dev_error = 'QMK: [E00] This is a dev error, please report this on the repo with your config',
	_strip = function(err) return string.gsub(err, '.*QMK:', 'QMK:', 2) end,
}

return E
