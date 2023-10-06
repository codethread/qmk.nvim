require('matcher_combinators.luassert')
local match = assert.combinators.match
local format_keymaps = require('qmk.format.qmk')
local testy = require('qmk._test_utils')

describe('format qmk', function()
	---@type { msg: string, input: { keymaps: qmk.Keymaps, options: qmk.Config }, output: string[] }[]
	local tests = {
		{
			msg = 'a multiple row keymap with missaligned keys spaces',
			input = {
				keymaps = {
					pos = { start = 0, final = 7 },
					keymaps = {
						{
							layer_name = '_FOO',
							pos = { start = 1, final = 3 },
							layout_name = 'LAYOUT',
							keys = {
								'KC_A',
								'KC_B',
								'MT(MOD_LALT, KC_ENT)',
								'KC_C',
								'KC_A',
								'MT(MOD_LALT, KC_ENT)',
								'KC_B',
								'KC_C',
							},
						},
						{
							layer_name = '_BOO',
							layout_name = 'LAYOUT',
							keys = {
								'KC_A',
								'KC_B',
								'KC_C',
								'KC_D',
								'KC_A',
								'KC_B',
								'KC_C',
								'KC_D',
							},
							pos = { start = 4, final = 6 },
						},
					},
				},
				options = testy.create_options({
					'x x x x',
					'x x x x',
				}),
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B                 , MT(MOD_LALT, KC_ENT) , KC_C,',
				'  KC_A , MT(MOD_LALT, KC_ENT) , KC_B                 , KC_C',
				'),',
				'',
				'[_BOO] = LAYOUT(',
				'  KC_A , KC_B , KC_C , KC_D,',
				'  KC_A , KC_B , KC_C , KC_D',
				')',
			},
		},
	}

	require('qmk._test_utils').for_each_test(tests, function(test)
		it(test.msg, function()
			local output = format_keymaps(test.input.keymaps, test.input.options)
			match(test.output, output)
		end)
	end)
end)
