local E = {
	dev_error = 'qmk.nvim: [E00] This is a dev error, please report this on the repo with your config',
	parse_error_msg = function(msg)
		return msg .. ' | see :help qmk-setup for available configuration options'
	end,

	keymaps_none = 'qmk.nvim: [E01] No keymaps found',
	keymaps_too_many = 'qmk.nvim: [E02] Found more than one keymap declaration',
	keymaps_overlap = 'qmk.nvim: [E03] One ore more keymap declarations overlap with the start and or end of the keymaps declaration',
	keymap_empty = function(name)
		return 'qmk.nvim: [E04] No keys found in keymap ' .. name
	end,

	config_too_many_keys = 'qmk.nvim: [E05] too many keys in the keymap for your configured layout',
	config_too_few_keys = 'qmk.nvim: [E06] not enough keys in the keymap for your configured layout',
	config_invalid_symbol = 'qmk.nvim: [E07] invalid layout, expected "x", "_" or "^"',
	config_invalid_span = 'qmk.nvim: [E08] invalid layout, expected a ^ in the key',

	config_missing = 'qmk.nvim: [E09] user_config is required for setup()',
	config_missing_required = 'qmk.nvim: [E10] config missing, required keys are name & layout',
	config_keymap_invalid_pair = function(key, value)
		return (
			'qmk.nvim: [E11] keymap_overrides must be a dictionary of string keys and values, invalid: { '
				.. key
			or 'nil' .. '=' .. value
			or 'nil' .. ' }'
		)
	end,

	layout_empty = 'qmk.nvim: [E12] layout is empty',
	layout_row_empty = 'qmk.nvim: [E13] layout.row is empty',
	layout_trailing_whitespace = 'qmk.nvim: [E14] layout starts or ends with whitespace, use a gap "_" or span "x^" to create spaces',
	layout_double_whitespace = 'qmk.nvim: [E15] layout contains two or more adjacent spaces, use a gap "_" or span "x^" to create spaces',
	layout_missing_padding = 'qmk.nvim: [E16] layout row missing padding, all rows must be the same length, use gap "_" to pad out empty columns',

	parse_unknown = function(prefix, option)
		return 'qmk.nvim: [E17] ' .. string.format('unknown option: %s%s', prefix, option)
	end,
	parse_invalid = function(prefix, option, expected, got)
		return 'qmk.nvim: [E18] '
			.. string.format(
				'invalid option: "%s%s", expected: %s, got: %s',
				prefix,
				option,
				expected,
				got
			)
	end,
}

return E
