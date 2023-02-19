local E = {
	keymaps_none = 'E01: No keymaps found',
	keymaps_too_many = 'E02: Found more than one keymap declaration',
	keymaps_overlap = 'E03: One ore more keymap declarations overlap with the start and or end of the keymaps "const" declaration',
	keymap_empty = function(name) return 'E04: No keys found in keymap ' .. name end,
}

return E
