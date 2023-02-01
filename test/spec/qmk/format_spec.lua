require 'matcher_combinators.luassert'
local Path = require 'plenary.path'

local simple_config = {
	name = 'test',
	layout = { { 'x' } },
}

describe('qmk', function()
	describe('api', function()
		it('is not configured by default', function()
			local qmk = require 'qmk'
			assert.is_false(qmk.is_configured())
		end)

		it('is configured after setup', function()
			local qmk = require 'qmk'
			qmk.setup(simple_config)
			assert.is_true(qmk.is_configured())
		end)
	end)

	describe('format', function()
		it('formats the buffer', function()
			local content = Path:new('test', 'fixtures', 'simple.c'):read()
			local out = Path:new('test', 'fixtures', 'simple_out.c'):read()
			local buff = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_buf_set_lines(buff, 0, -1, false, vim.split(content, '\n', {}))
			local qmk = require 'qmk'
			qmk.setup(simple_config)
			qmk.format(buff)
			assert.combinators.match(
				vim.split(out, '\n', {}),
				vim.api.nvim_buf_get_lines(buff, 0, -1, false)
			)
		end)
	end)

	describe('display', function()
		it('displays the keymap in a popup', function() assert.is_true(true) end)
	end)
end)
