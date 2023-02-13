require 'matcher_combinators.luassert'

describe('get_keymaps', function()
	local tests = {
		{
			msg = 'normal hi',
			input = [[
                    const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
                        [_FOO] = LAYOUT(
                            KC_A, KC_B, MT(MOD_LALT, KC_ENT), KC_C
                        ),
                        [_BOO] = LAYOUT(
                            KC_A, KC_B, KC_C,
                        ),
                    };
                ]],
			output = [[
                    const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
                        [_FOO] = LAYOUT(
                            KC_A, KC_B, KC_C
                        ),
                    };
                ]],
		},
	}

	-- loop through tests and run them
	for _, test in pairs(tests) do
		it(test.msg, function()
			local get_keymaps = require 'qmk.get_keymaps'
			local s = get_keymaps(test.input, { name = 'LAYOUT' })

			assert.combinators.match(s.keymaps, { 'string' })
		end)
	end
end)
