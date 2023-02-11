require 'matcher_combinators.luassert'
local Path = require 'plenary.path'

-- TODO: will need to set this up per test most likely
local simple_config = {
	name = 'test',
	layout = { { 'x' } },
}

local function snapshot(input, final)
	local content = Path:new('test', 'fixtures', input):read()
	local out = Path:new('test', 'fixtures', final):read()
	local buff = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buff, 0, -1, false, vim.split(content, '\n', {}))

	return {
		-- expected text as list of lines
		expected = vim.split(out, '\n', {}),
		-- buffer handle
		buff = buff,
		-- function to get buffer content as list of lines
		buff_content = function() return vim.api.nvim_buf_get_lines(buff, 0, -1, false) end,
	}
end

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
			local T = snapshot('simple.c', 'simple_out.c')

			local qmk = require 'qmk'
			qmk.setup(simple_config)
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats the buffer with multiple keymaps', function()
			local T = snapshot('multiple.c', 'multiple_out.c')

			local qmk = require 'qmk'
			qmk.setup(simple_config)
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats overlapping keymaps onto seperate lines', function()
			local T = snapshot('overlap.c', 'overlap_out.c')

			local qmk = require 'qmk'
			qmk.setup(simple_config)
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)
	end)

	describe('display', function()
		it('displays the keymap in a popup', function() assert.is_true(true) end)
	end)
end)
