local match = assert.combinators.match
local format = require 'qmk.format.keymap'
local config = require 'qmk.config'

---@param layout qmk.UserLayout
---@return qmk.Config
local function create_options(layout)
	return config.parse {
		name = 'test',
		layout = layout,
	}
end

---@param layout qmk.UserLayout
---@return qmk.Config
local function create_options_preview(layout)
	return config.parse {
		name = 'test',
		layout = layout,
		comment_preview = { position = 'top' },
	}
end

describe('keymaps', function()
	---@type { only?: boolean, msg: string, input: { keys: string[], options: qmk.Config }, output: string[] }[]
	local tests = {
		{
			msg = 'a single space',
			input = {
				options = create_options { '| x' },
				keys = { 'KC_A' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'      KC_A',
			},
		},
		{
			msg = 'wide keys',
			input = {
				options = create_options { 'x x', 'x x' },
				keys = { 'KC_A', 'MT(MOD_LALT)', 'MT(MOD_LALT)', 'KC_D' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A         , MT(MOD_LALT),',
				'  MT(MOD_LALT) , KC_D        ',
			},
		},
		{
			msg = 'a single row keymap',
			input = {
				options = create_options { 'x x x x' },
				keys = { 'KC_A', 'KC_B', 'MT(MOD_LALT, KC_ENT)', 'KC_C' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B , MT(MOD_LALT, KC_ENT) , KC_C',
			},
		},
		{
			msg = 'a single row keymap with gap',
			input = {
				options = create_options { 'x x | x x' },
				keys = { 'KC_A', 'KC_B', 'MT(MOD_LALT, KC_ENT)', 'KC_C' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B ,     MT(MOD_LALT, KC_ENT) , KC_C',
			},
		},
		{
			msg = 'a double row keymap with gap',
			input = {
				options = create_options_preview {
					'x x | x x',
					'| | | | x',
				},
				keys = { '1', '2', 'long_key', '4', '5' },
			},
			output = {
				'//    ┌───┬───┐   ┌──────────┬───┐',
				'//    │ 1 │ 2 │   │ long_key │ 4 │',
				'//    └───┴───┘   └──────────┼───┤',
				'//                           │ 5 │',
				'//                           └───┘',
				'[_FOO] = LAYOUT(',
				'  1 , 2 ,     long_key , 4,',
				'                         5',
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
				'  KC_A , KC_B,',
				'     KC_C    ',
			},
		},
		{
			msg = 'simple with lots of gaps',
			input = {
				options = create_options_preview {
					'x x x x x x x',
					'x^x | | | | x',
				},
				keys = { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
			},
			output = {
				'//    ┌───┬───┬───┬───┬───┬───┬───┐',
				'//    │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │',
				'//    ├───┴───┼───┴───┴───┴───┼───┤',
				'//    │   8   │               │ 9 │',
				'//    └───────┘               └───┘',
				'[_FOO] = LAYOUT(',
				'  1 , 2 , 3 , 4 , 5 , 6 , 7,',
				'    8   ,                 9',
			},
		},
		{
			msg = 'simple multiple rows',
			input = {
				options = create_options {
					'x x',
					'x x',
					'x^x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_E', 'KC_D(Mod)', 'KC_C' },
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B     ,',
				'  KC_E , KC_D(Mod),',
				'        KC_C      ',
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
				'  KC_A , KC_B , KC_C,',
				'     KC_A     , KC_A',
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
				'  KC_A , KC_B , MT(MOD_LALT, KC_ENT) , KC_C , KC_5 , KC_6,',
				'         KC_7 , KC_8                 ,        KC_9       ',
			},
		},
		{
			msg = 'complex',
			input = {
				options = create_options {
					'x x x | x x x',
					'xx^ x | xx^xx',
					'x x x | x x x',
				},
                -- stylua: ignore
				keys = {
					'KC_A', 'KC_B', 'MT(MOD_LALT, KC_ENT)', 'KC_C', 'KC_5', 'KC_6',
					'KC_7', 'KC_8', 'KC_9',
					'KC_C', 'KC_5', 'KC_6', 'KC_7', 'KC_8', 'KC_9',
				},
				-- stylua: ignore end
			},
			output = {
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B , MT(MOD_LALT, KC_ENT) ,     KC_C , KC_5 , KC_6,',
				'         KC_7 , KC_8                 ,            KC_9       ,',
				'  KC_C , KC_5 , KC_6                 ,     KC_7 , KC_8 , KC_9',
			},
		},

		-- with preview
		{
			msg = 'simple double row with preview',
			input = {
				options = create_options_preview {
					'x x',
					'x^x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_C' },
			},
			output = {
				'//    ┌───┬───┐',
				'//    │ a │ b │',
				'//    ├───┴───┤',
				'//    │   c   │',
				'//    └───────┘',
				'[_FOO] = LAYOUT(',
				'  KC_A , KC_B,',
				'     KC_C    ',
			},
		},
		{
			msg = 'spaced double row with preview',
			input = {
				options = create_options_preview {
					'| x x',
					'| x^x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_C' },
			},
			output = {
				'//        ┌───┬───┐',
				'//        │ a │ b │',
				'//        ├───┴───┤',
				'//        │   c   │',
				'//        └───────┘',
				'[_FOO] = LAYOUT(',
				'      KC_A , KC_B,',
				'         KC_C    ',
			},
		},
		{
			msg = 'double overlap with rows',
			input = {
				options = create_options_preview {
					'x xx^',
					'x^x x',
					'x x x',
				},
				keys = { 'KC_A', 'KC_B', 'KC_C', 'KC_D', 'KC_E', 'KC_F', 'KC_G' },
			},
			output = {
				'//    ┌───┬───────┐',
				'//    │ a │   b   │',
				'//    ├───┴───┬───┤',
				'//    │   c   │ d │',
				'//    ├───┬───┼───┤',
				'//    │ e │ f │ g │',
				'//    └───┴───┴───┘',
				'[_FOO] = LAYOUT(',
				'  KC_A ,        KC_B,',
				'     KC_C     , KC_D,',
				'  KC_E , KC_F , KC_G',
			},
		},
		{
			msg = 'wide test',
			input = {
				options = create_options_preview {
					'x x x',
					'xx^xx',
				},
				keys = { 'AA', 'B', 'C', 'D' },
			},
			output = {
				'//    ┌────┬───┬───┐',
				'//    │ AA │ B │ C │',
				'//    ├────┴───┴───┤',
				'//    │     D      │',
				'//    └────────────┘',
				'[_FOO] = LAYOUT(',
				'  AA , B , C,',
				'      D     ',
			},
		},
		{
			msg = 'overlap test',
			input = {
				options = create_options_preview {
					'x xx^',
					'x^x x',
					'xx^xx',
				},
				keys = { 'AA', 'B', 'C', 'D', 'E' },
			},
			output = {
				'//    ┌────┬───────┐',
				'//    │ AA │   B   │',
				'//    ├────┴───┬───┤',
				'//    │   C    │ D │',
				'//    ├────────┴───┤',
				'//    │     E      │',
				'//    └────────────┘',
				'[_FOO] = LAYOUT(',
				'  AA ,     B,',
				'    C    , D,',
				'      E     ',
			},
		},
		{
			msg = 'long keys with overlap',
			input = {
				options = create_options_preview {
					'x xx^',
					'x^x x',
					'x x x',
				},
				keys = {
					'KC_A',
					'KC_B',
					'KC_C',
					'KC_D',
					'KC_E',
					'Really long key but should pad',
					'KC_G',
				},
			},
			output = {
				'//    ┌───┬────────────────────────────────────┐',
				'//    │ a │                 b                  │',
				'//    ├───┴────────────────────────────────┬───┤',
				'//    │                 c                  │ d │',
				'//    ├───┬────────────────────────────────┼───┤',
				'//    │ e │ Really long key but should pad │ g │',
				'//    └───┴────────────────────────────────┴───┘',
				'[_FOO] = LAYOUT(',
				'  KC_A ,                                  KC_B,',
				'                  KC_C                  , KC_D,',
				'  KC_E , Really long key but should pad , KC_G',
			},
		},
		{
			msg = 'mini kinesis',
			input = {
				options = create_options_preview {
					'x x x x x x x x x x x x x x',
					'x x x x | | | | | | x x x x',
					'| x x | | | | | | | | x x |',
					'| | | x^x | | | | x^x | | |',
					'| | | | x | | | | x | | | |',
					'| | x x x | | | | x x x | |',
				},
                -- stylua: ignore
				keys = {
					'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11',
					'12', '13', '14', '15', '16', '17', '18', '19', '20', '21',
					'22', '23', '24', '2005', '26', '27', '28', '29', '30', '31',
					'32', '33', '34', '35', '36',
                },
				-- stylua: ignore end
			},
			output = {
				'//    ┌────┬────┬────┬────┬────┬───┬───┬───┬───┬────┬────┬──────┬────┬────┐',
				'//    │ 1  │ 2  │ 3  │ 4  │ 5  │ 6 │ 7 │ 8 │ 9 │ 10 │ 11 │  12  │ 13 │ 14 │',
				'//    ├────┼────┼────┼────┼────┴───┴───┴───┴───┴────┼────┼──────┼────┼────┤',
				'//    │ 15 │ 16 │ 17 │ 18 │                         │ 19 │  20  │ 21 │ 22 │',
				'//    └────┼────┼────┼────┘                         └────┼──────┼────┼────┘',
				'//         │ 23 │ 24 │                                   │ 2005 │ 26 │     ',
				'//         └────┴────┼─────────┐               ┌─────────┼──────┴────┘     ',
				'//                   │   27    │               │   28    │                 ',
				'//                   └────┬────┤               ├────┬────┘                 ',
				'//                        │ 29 │               │ 30 │                      ',
				'//              ┌────┬────┼────┤               ├────┼────┬──────┐          ',
				'//              │ 31 │ 32 │ 33 │               │ 34 │ 35 │  36  │          ',
				'//              └────┴────┴────┘               └────┴────┴──────┘          ',
				'[_FOO] = LAYOUT(',
				'  1  , 2  , 3  , 4  , 5  , 6 , 7 , 8 , 9 , 10 , 11 , 12   , 13 , 14,',
				'  15 , 16 , 17 , 18 ,                           19 , 20   , 21 , 22,',
				'       23 , 24 ,                                     2005 , 26     ,',
				'                   27    ,                   28                    ,',
				'                      29 ,                 30                      ,',
				'            31 , 32 , 33 ,                 34 , 35 , 36            ',
			},
		},
	}

	for _, test in pairs(tests) do
		if not test.only then
			it(test.msg, function()
				local keymap = {
					layer_name = '_FOO',
					pos = { start = 1, final = 3 },
					layout_name = 'LAYOUT',
					keys = test.input.keys,
				}
				local output = format(test.input.options, keymap)
				match(test.output, output)
			end)
		end
	end
end)
