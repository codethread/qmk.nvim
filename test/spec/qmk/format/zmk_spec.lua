require('matcher_combinators.luassert')
local match = assert.combinators.match
local format_keymaps = require('qmk.format.zmk')
local testy = require('qmk._test_utils')

describe('format zmk', function()
	---@type { msg: string, input: { keymaps: qmk.Keymap, options: qmk.Config }, output: qmk.ZMKResult }[]
	local tests = {
		{
			msg = 'a multiple row keymap with missaligned keys spaces',
			input = {
				keymaps = {
					layer_name = '_FOO',
					pos = { start = 1, final = 3 },
					layout_name = 'LAYOUT',
					keys = {
						'KC_A',
						'KC_B',
						'MT(MOD_LALT, KC_ENT)',
						'KC_B',
					},
				},
				options = testy.create_options({
					'x x',
					'x x',
				}, 'zmk'),
			},
			output = {
				pos = { start = 1, final = 3 },
				layer_name = '_FOO',
				keys = {
					'  KC_A                   KC_B',
					'  MT(MOD_LALT, KC_ENT)   KC_B',
				},
			},
		},
	}

	for _, test in pairs(tests) do
		it(test.msg, function()
			local output = format_keymaps(test.input.keymaps, test.input.options)
			match(test.output, output)
		end)
	end
end)
