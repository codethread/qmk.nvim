local for_each_test = require('qmk._test_utils').for_each_test
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
				output = E.config_missing,
			},
			{
				msg = 'missing required key',
				only = true,
				input = { layout = { 'x' }, timeout = -9, variant = 'foo' },
				output = E.config_missing_required,
			},
			{
				msg = 'invalid key',
				input = none_missing({ foo = {} }),
				output = E.parse_error_msg(E.parse_unknown('', 'foo')),
			},
			{
				msg = 'invalid param',
				input = none_missing({
					auto_format_pattern = {},
					comment_preview = {
						position = 4,
					},
				}),
				output = E.parse_error_msg(
					E.parse_invalid('', 'auto_format_pattern', 'string', 'table')
				),
			},
			{
				msg = 'invalid nested param',
				input = none_missing({
					comment_preview = { keymap_overrides = 0 },
				}),
				output = E.parse_error_msg(
					E.parse_invalid('comment_preview.', 'keymap_overrides', 'table', 'number')
				),
			},
			{
				msg = 'invalid complex param',
				input = none_missing({ comment_preview = { position = 'foo' } }),
				output = 'qmk.nvim: [E18] invalid option: "comment_preview.position", expected: one of top, bottom, inside, none,'
					.. ' got: foo | see :help qmk-setup for available configuration options',
			},
			{
				msg = 'invalid layout empty',
				input = none_missing({ layout = {} }),
				output = E.layout_empty,
			},
			{
				msg = 'invalid layout empty row',
				input = none_missing({ layout = { '' } }),
				output = E.layout_row_empty,
			},
			{
				msg = 'invalid layout uneven',
				input = none_missing({ layout = { 'x', 'x x' } }),
				output = E.layout_missing_padding,
			},
			{
				msg = 'invalid layout trailing space',
				input = none_missing({ layout = { ' x' } }),
				output = E.layout_trailing_whitespace,
			},
			{
				msg = 'invalid layout leading space',
				input = none_missing({ layout = { 'x ' } }),
				output = E.layout_trailing_whitespace,
			},
			{
				msg = 'invalid layout invalid double space',
				input = none_missing({ layout = { 'x  x', 'x  x' } }),
				output = E.layout_double_whitespace,
			},
			{
				msg = 'invalid layout symbol',
				input = none_missing({ layout = { 'x x y' } }),
				output = E.config_invalid_symbol,
			},
			{
				msg = 'invalid layout span',
				input = none_missing({ layout = { 'x xxx' } }),
				output = E.config_invalid_span,
			},
		}

		for_each_test(tests, function(test)
			it(test.msg, function()
				local ok, err = pcall(config.parse, test.input)
				assert(not ok, 'no error thrown')
				match(match_string.equals(test.output), err)
			end)
		end)
	end)
end)
