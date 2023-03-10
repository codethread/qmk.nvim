local match = assert.combinators.match
local format_keymaps = require 'qmk.format.keymaps'
local config = require 'qmk.config'

---@param layout qmk.UserLayout
---@return qmk.Config
local function create_options(layout)
	return config.parse {
		name = 'test',
		layout = layout,
	}
end

describe('format_keymaps', function()
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
				options = create_options {
					'x x x x',
					'x x x x',
				},
			},
			output = {
				'[_FOO] = LAYOUT(',
				'KC_A , KC_B                 , MT(MOD_LALT, KC_ENT) , KC_C,',
				'KC_A , MT(MOD_LALT, KC_ENT) , KC_B                 , KC_C',
				'),',
				'',
				'[_BOO] = LAYOUT(',
				'KC_A , KC_B , KC_C , KC_D,',
				'KC_A , KC_B , KC_C , KC_D',
				')',
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
