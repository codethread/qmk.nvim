local E = require('qmk.errors')
local match = assert.combinators.match
local match_string = require('matcher_combinators.matchers.string')
local config = require('qmk.config')

local function none_missing(conf)
	return vim.tbl_deep_extend('force', { name = 'test', layout = { 'x' } }, conf)
end

describe('config', function()
	describe('abuse', function()
		local tests = {
			{
				msg = 'no config',
				input = nil,
				err = E.config_missing,
			},
			{
				msg = 'no name',
				input = { layout = { 'x' } },
				err = E.config_missing_required,
			},
			{
				msg = 'no layout',
				input = { name = 'test' },
				err = E.config_missing_required,
			},
			{
				msg = 'invalid key',
				input = none_missing({ foo = {} }),
				err = E.parse_error_msg(E.parse_unknown('', 'foo')),
			},
			{
				msg = 'invalid param',
				input = none_missing({ spacing = {} }),
				err = E.parse_error_msg(E.parse_invalid('', 'spacing', 'number', 'table')),
			},
			{
				msg = 'invalid nested param',
				input = none_missing({
					comment_preview = { keymap_overrides = 0 },
				}),
				err = E.parse_error_msg(
					E.parse_invalid('comment_preview.', 'keymap_overrides', 'table', 'number')
				),
			},
			{
				msg = 'invalid complex param',
				input = none_missing({ comment_preview = { position = 'foo' } }),
				err = 'QMK: [E14] invalid option: "comment_preview.position", expected: one of top, bottom, inside, none,'
					.. ' got: foo | see :help qmk-setup for available configuration options',
			},
			{
				msg = 'invalid layout empty',
				input = none_missing({ layout = {} }),
				err = E.layout_empty,
			},
			{
				msg = 'invalid layout empty row',
				input = none_missing({ layout = { '' } }),
				err = E.layout_row_empty,
			},
			{
				msg = 'invalid layout trailing space',
				input = none_missing({ layout = { ' x' } }),
				err = E.layout_trailing_whitespace,
			},
			{
				msg = 'invalid layout leading space',
				input = none_missing({ layout = { 'x ' } }),
				err = E.layout_trailing_whitespace,
			},
			{
				msg = 'invalid layout invalid double space',
				input = none_missing({ layout = { 'x x', 'x  x' } }),
				err = E.layout_double_whitespace,
			},
			{
				msg = 'invalid layout symbol',
				input = none_missing({ layout = { 'x x y' } }),
				err = E.config_invalid_symbol,
			},
			{
				msg = 'invalid layout span',
				input = none_missing({ layout = { 'x xxx' } }),
				err = E.config_invalid_span,
			},
		}

		for _, test in pairs(tests) do
			it(test.msg, function()
				local ok, err = pcall(config.parse, test.input)
				assert(not ok, 'no error thrown')
				match(match_string.equals(test.err), E._strip(err))
			end)
		end
	end)
end)
