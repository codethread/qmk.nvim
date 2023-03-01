local E = require 'qmk.errors'
local match = assert.combinators.match
local match_string = require 'matcher_combinators.matchers.string'
local config = require 'qmk.config'

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
				msg = 'invalid spacing',
				input = none_missing { spacing = {} },
				err = E.config_missing,
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
