local M = {}

-- use for validation
---@type qmk.UserConfig
M.required_fields = {
	name = '',
	layout = { '' },
}

---@type qmk.UserConfig
M.default_config = {
	name = '',
	layout = { '' },
	variant = 'qmk',
	timeout = 5000,
	auto_format_pattern = { '*keymap.c', '*.keymap' },
	comment_preview = {
		position = 'top',
		keymap_overrides = {},
		symbols = {
			space = ' ',
			horz = '─',
			vert = '│',
			tl = '┌',
			tm = '┬',
			tr = '┐',
			ml = '├',
			mm = '┼',
			mr = '┤',
			bl = '└',
			bm = '┴',
			br = '┘',
		},
	},
}

return M
