local E = require('qmk.errors')
local match = assert.combinators.match
local match_string = require('matcher_combinators.matchers.string')
local qmk_parser = require('qmk.parse.qmk')
local parser = require('qmk.parse').parse

describe('parse qmk keymaps:', function()
	---@type {msg: string, input: string, output: qmk.Keymaps}[]
	local tests = {
		{
			msg = 'simple keymap',
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
			output = {
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
						},
					},
					{
						layer_name = '_BOO',
						layout_name = 'LAYOUT',
						keys = { 'KC_A', 'KC_B', 'KC_C' },
						pos = { start = 4, final = 6 },
					},
				},
			},
		},
		{
			msg = 'overlapping keymap',
			input = [[
                    const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
                        [_FOO] = LAYOUT(
                            KC_A, KC_B, MT(MOD_LALT, KC_ENT), KC_C
                        ), [_BOO] = LAYOUT( KC_A, KC_B, KC_C,
                        ),
                    };
                ]],
			output = {
				pos = { start = 0, final = 5 },
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
						},
					},
					{
						layer_name = '_BOO',
						layout_name = 'LAYOUT',
						keys = { 'KC_A', 'KC_B', 'KC_C' },
						pos = { start = 3, final = 4 },
					},
				},
			},
		},
		{
			msg = 'single line',
			input = [[
                    const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
                    [_FOO] = LAYOUT( KC_A, KC_B, MT(MOD_LALT, KC_ENT), KC_C), [_BOO] = LAYOUT( KC_A, KC_B, KC_C,),
                    };
                ]],
			output = {
				pos = { start = 0, final = 2 },
				keymaps = {
					{
						layer_name = '_FOO',
						pos = { start = 1, final = 1 },
						layout_name = 'LAYOUT',
						keys = {
							'KC_A',
							'KC_B',
							'MT(MOD_LALT, KC_ENT)',
							'KC_C',
						},
					},
					{
						layer_name = '_BOO',
						layout_name = 'LAYOUT',
						keys = { 'KC_A', 'KC_B', 'KC_C' },
						pos = { start = 1, final = 1 },
					},
				},
			},
		},
		{
			msg = 'many lines',
			input = [[
                const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
                    [_FOO]
                    =
                    LAYOUT(
                    KC_A,
                    KC_B,
                    MT(MOD_LALT,
                    KC_ENT),
                    KC_C),
                    [_BOO]
                    =
                    LAYOUT(
                    KC_A,
                    KC_B,
                    A(
                     B, C(
                        D   , E() )
                        )
                    KC_C,),
                };
                ]],
			output = {
				pos = { start = 0, final = 19 },
				keymaps = {
					{
						layer_name = '_FOO',
						pos = { start = 1, final = 8 },
						layout_name = 'LAYOUT',
						keys = {
							'KC_A',
							'KC_B',
							'MT(MOD_LALT, KC_ENT)',
							'KC_C',
						},
					},
					{
						layer_name = '_BOO',
						layout_name = 'LAYOUT',
						keys = { 'KC_A', 'KC_B', 'A(B, C(D, E()))', 'KC_C' },
						pos = { start = 9, final = 14 },
					},
				},
			},
		},
	}

	for _, test in pairs(tests) do
		local all_keymaps = parser(test.input, { name = 'LAYOUT' }, qmk_parser)

		it('for layout "' .. test.msg .. '" gets the correct pos', function()
			match(test.output.pos, all_keymaps.pos)
		end)

		for i, keymap in pairs(all_keymaps.keymaps) do
			local expected = test.output.keymaps[i]
			it(
				'for layout "'
					.. test.msg
					.. '" layer "'
					.. (expected.layer_name or 'NOT_FOUND')
					.. '"',
				function()
					match(expected, keymap)
				end
			)
		end
	end
end)

describe('parse qmk keymaps abuse:', function()
	---@type { msg: string, err: string, input: string }[]
	local tests = {
		{
			msg = 'no code',
			err = E.keymaps_none,
			input = '',
		},
		{
			msg = 'no keymaps, but the overlap triggers first',
			err = E.keymaps_overlap,
			input = 'const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = { };',
		},
		{
			msg = 'no keymaps',
			err = E.keymaps_none,
			input = 'const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {\n};',
		},
		{
			msg = 'malformed',
			err = E.keymaps_none,
			input = 'const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =  };',
		},
		{
			msg = 'empty keymap',
			err = E.keymap_empty('_FOO'),
			input = [[
              const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =  {
              [_FOO] = LAYOUT()
              }; ]],
		},
		{
			msg = 'empty keymap amoungst valid ones',
			err = E.keymap_empty('_FOO'),
			input = [[
              const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =  {
              [_OO] = LAYOUT(A),
              [_FOO] = LAYOUT(),
              [_FO] = LAYOUT(B),
              }; ]],
		},
		{
			msg = 'start line overlaps',
			err = E.keymaps_overlap,
			input = [[
            const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = { [_FOO] = LAYOUT(KC_A),
            };
            ]],
		},
		{
			msg = 'last line overlaps',
			err = E.keymaps_overlap,
			input = [[
            const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
            [_FOO] = LAYOUT(KC_A), };
            ]],
		},
		{
			msg = 'both lines overlap',
			err = E.keymaps_overlap,
			input = 'const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = { [_FOO] = LAYOUT(KC_A), };',
		},
	}

	for _, test in pairs(tests) do
		it('should fail when ' .. test.msg, function()
			local ok, err = pcall(parser, test.input, { name = 'LAYOUT' }, qmk_parser)
			assert(not ok, 'no error thrown')
			match(match_string.equals(test.err), err)
		end)
	end
end)
