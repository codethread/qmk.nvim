local E = require('qmk.errors')
local match = assert.combinators.match
local match_string = require('matcher_combinators.matchers.string')
local zmk_parser = require('qmk.parse.zmk')
local parser = require('qmk.parse').parse

local layout_name = 'ZMK'

---@param keys string
---@return string
local function create_keymap(keys)
	return [[
/ {
    keymap {
        default_layer {
            bindings = <
            ]] .. keys .. [[
            >;
        };
    };
};
    ]]
end

---@param keymaps qmk.Keymap[]
---@return qmk.Keymaps
local function create_output(keymaps)
	return {
		pos = { start = 0, final = 10000000 },
		keymaps = keymaps,
	}
end

describe('parse zmk keymaps:', function()
	---@type {msg: string, input: string, output: qmk.Keymaps}[]
	local tests = {
		{
			msg = 'simple keymap',
			input = create_keymap([[ &kp A &kp B &kp C ]]),
			output = create_output({
				{
					layer_name = 'default_layer',
					pos = { start = 3, final = 4 },
					layout_name = layout_name,
					keys = { '&kp A', '&kp B', '&kp C' },
				},
			}),
		},
		{
			msg = 'multi key keymap',
			input = create_keymap(
				[[ &kp A 3 ESC &kp LSHFT PG_UP _AS(Z) &mt LC(LG(_LS(LALT)) )&kp C ]]
			),
			output = create_output({
				{
					layer_name = 'default_layer',
					pos = { start = 3, final = 4 },
					layout_name = layout_name,
					keys = {
						'&kp A 3 ESC',
						'&kp LSHFT PG_UP',
						'_AS(Z)',
						'&mt LC(LG(_LS(LALT)) )',
						'&kp C',
					},
				},
			}),
		},
		{
			msg = 'multiple keymaps',
			input = [[
            / {
                keymap {
                    default_layer {
                        bindings = <
                            &kp A &kp B &kp C
                        >;
                    };

                    alt_layer {
                        bindings = <
                            &kp D &kp E &kp C
                        >;
                    };
                };
            };
            ]],
			output = create_output({
				{
					layer_name = 'default_layer',
					pos = { start = 3, final = 5 },
					layout_name = layout_name,
					keys = { '&kp A', '&kp B', '&kp C' },
				},
				{
					layer_name = 'alt_layer',
					pos = { start = 9, final = 11 },
					layout_name = layout_name,
					keys = { '&kp D', '&kp E', '&kp C' },
				},
			}),
		},
	}

	for _, test in pairs(tests) do
		local all_keymaps = parser(test.input, { name = 'ZMK' }, zmk_parser)

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

pending('parse zmk keymaps abuse:', function()
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
			local ok, err = pcall(parser, test.input, { name = 'LAYOUT' }, zmk_parser)
			assert(not ok, 'no error thrown')
			match(match_string.equals(test.err), err)
		end)
	end
end)
