require 'matcher_combinators.luassert'
local Path = require 'plenary.path'

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
			qmk.setup { name = 'test', layout = { 'x' } }
			assert.is_true(qmk.is_configured())
		end)

		it('warns of invalid config but does not throw', function()
			local qmk = require 'qmk'
			local spy = require 'luassert.spy'
			spy.on(vim, 'notify')
			local ok = pcall(qmk.setup)
			assert(ok, 'no error thrown')
			assert.spy(vim.notify).was_called()
		end)
	end)

	describe('format', function()
		it('formats the buffer', function()
			local T = snapshot('simple.c', 'simple_out.c')

			local qmk = require 'qmk'
			qmk.setup {
				name = 'LAYOUT_preonic_grid',
				layout = {
					'| x x x x x x x x x x x x',
					'| x x x x x x x x x x x x',
					'| x x x x x x x x x x x x',
					'| x x x x x x x x x x x x',
					'| x x x x x x x x x x x x',
				},
			}
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats the buffer with multiple keymaps', function()
			local T = snapshot('multiple.c', 'multiple_out.c')

			local qmk = require 'qmk'
			qmk.setup {
				name = 'LAYOUT_preonic_grid',
				spacing = 8,
				comment_preview = {
					position = 'top',
				},
				layout = {
					'x x x x x x | | x x x x x x',
					'x x x x x x | | x x x x x x',
					'x x x x x x | | x x x x x x',
					'x x x x x x | | x x x x x x',
					'x x x x x x | | x x x x x x',
				},
			}
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats overlapping keymaps onto seperate lines', function()
			local T = snapshot('overlap.c', 'overlap_out.c')

			local qmk = require 'qmk'
			qmk.setup {
				name = 'LAYOUT_preonic_grid',
				layout = { '| x x x x x' },
			}
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)
	end)

	describe('display', function()
		it('displays the keymap in a popup', function() assert.is_true(true) end)
	end)
end)
