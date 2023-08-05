local match = assert.combinators.match
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

---@param keymaps qmk.KeymapsList
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

-- TODO
-- describe('parse zmk keymaps abuse:', function()
-- end)
