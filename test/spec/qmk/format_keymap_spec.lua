local match = assert.combinators.match
local format_keymap = require 'qmk.format_keymap'
local config = require 'qmk.config'

---@param layout qmk.UserLayout
---@return qmk.Config
local function create_options(layout)
	return vim.tbl_deep_extend('force', config.default_config, { layout = layout })
end

describe('format_keymaps', function()
	---@type { msg: string, input: { keys: string[], options: qmk.Config }, output: string[] }[]
	local tests = {
		{
			msg = 'a single row keymap',
			input = {
				options = create_options { 'x x x x' },
				keys = { 'KC_A', 'KC_B', 'MT(MOD_LALT, KC_ENT)', 'KC_C' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'KC_A , KC_B , MT(MOD_LALT, KC_ENT) , KC_C',
			},
		},
		{
			msg = 'simple double row',
			input = {
				options = create_options {
					'x x',
					'x^x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_C' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'KC_A , KC_B',
				'   KC_C    ',
			},
		},
		{
			msg = 'simple double row',
			input = {
				options = create_options {
					'x x x',
					'x^x x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_C', 'KC_A', 'KC_A' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'KC_A , KC_B , KC_C',
				'   KC_A     , KC_A',
			},
		},
		{
			msg = 'multiple row keymap with spaces',
			input = {
				options = create_options {
					'x x x x x x',
					'xx^ x xx^xx',
				},
				keys = {
					'KC_A',
					'KC_B',
					'MT(MOD_LALT, KC_ENT)',
					'KC_C',
					'KC_5',
					'KC_6',
					'KC_7',
					'KC_8',
					'KC_9',
				},
			},
			output = {
				'[_FOO] = LAYOUT(',
				'KC_A , KC_B , MT(MOD_LALT, KC_ENT) , KC_C , KC_5 , KC_6',
				'       KC_7 , KC_8                 ,        KC_9       ',
			},
		},
	}

	for _, test in pairs(tests) do
		it(test.msg, function()
			local keymap = {
				layer_name = '_FOO',
				pos = { start = 1, final = 3 },
				layout_name = 'LAYOUT',
				keys = test.input.keys,
			}
			local output = format_keymap(test.input.options, keymap)
			match(test.output, output)
		end)
	end
end)
