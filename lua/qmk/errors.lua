local E = {
	keymaps_none = 'E01: No keymaps found',
	keymaps_too_many = 'E02: Found more than one keymap declaration',
	keymaps_overlap = 'E03: One ore more keymap declarations overlap with the start and or end of the keymaps "const" declaration',
	keymap_empty = function(name) return 'E04: No keys found in keymap ' .. name end,
	config_mismatch = 'E05: no enough keys for layout',
	config_invalid_symbol = 'E06: invalid layout, expected "x", "|" or "^"',
	config_invalid_span = 'E07: invalid layout, expected a ^ in the key',
	config_missing = 'E08: user_config is required for setup()',
	layout_trailing_whitespace = 'E09: layout starts or ends with whitespace, use a break "|" or span "x^" to create spaces',
	layout_double_whitespace = 'E10: layout contains two or more adjacent spaces, use a break "|" or span "x^" to create spaces',
}

return E
