require 'matcher_combinators.luassert'
local spy = require 'luassert.spy'
local const = require 'qmk.const'

local simple_config = {
	name = 'test',
	layout = { { 'x' } },
}

describe('qmk format', function()
	it('returns if configured', function()
		local qmk = require 'qmk'
		assert.is_false(qmk.is_configured())
		qmk.setup(simple_config)
		assert.is_true(qmk.is_configured())
	end)

	it('does not run if not configured', function()
		require('plenary.reload').reload_module 'qmk'
		local qmk = require 'qmk'
		spy.on(vim, 'notify')
		qmk.format()
		assert.spy(vim.notify).was_called_with(const.configured_warning, vim.log.levels.WARN)
	end)

	it('formats the buffer', function()
		local qmk = require 'qmk'
		qmk.setup(simple_config)
	end)
end)
