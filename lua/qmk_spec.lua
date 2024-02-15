local testy = require('qmk._test_utils')
require('matcher_combinators.luassert')

describe('qmk', function()
	describe('api', function()
		it('is not configured by default', function()
			local qmk = require('qmk')
			assert.is_false(qmk.is_configured())
		end)

		it('is configured after setup', function()
			local qmk = require('qmk')
			qmk.setup({ name = 'test', layout = { 'x' } })
			assert.is_true(qmk.is_configured())
		end)

		it('warns of invalid config but does not throw', function()
			local qmk = require('qmk')
			local spy = require('luassert.spy')
			spy.on(vim, 'notify')
			local ok = pcall(qmk.setup)
			assert(ok, 'no error should be thrown')
			assert.spy(vim.notify).was_called()
		end)
	end)

	describe('format', function()
		it('formats the buffer', function()
			local T = testy.snapshot('simple.c')

			local qmk = require('qmk')
			qmk.setup({
				name = 'LAYOUT_preonic_grid',
				comment_preview = { position = 'none' },
				layout = {
					'_ x x x x x x x x x x x x',
					'_ x x x x x x x x x x x x',
					'_ x x x x x x x x x x x x',
					'_ x x x x x x x x x x x x',
					'_ x x x x x x x x x x x x',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats the buffer with multiple keymaps', function()
			local T = testy.snapshot('multiple.c')

			local qmk = require('qmk')
			qmk.setup({
				name = 'LAYOUT_preonic_grid',
				layout = {
					'x x x x x x _ _ x x x x x x',
					'x x x x x x _ _ x x x x x x',
					'x x x x x x _ _ x x x x x x',
					'x x x x x x _ _ x x x x x x',
					'x x x x x x _ _ x x x x x x',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats overlapping keymaps onto seperate lines', function()
			local T = testy.snapshot('overlap.c')

			local qmk = require('qmk')
			qmk.setup({
				name = 'LAYOUT_preonic_grid',
				comment_preview = { position = 'none' },
				layout = { '_ x x x x x' },
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats numbers in keymaps', function()
			local T = testy.snapshot('numbers.c')

			local qmk = require('qmk')
			qmk.setup({
				name = 'LAYOUT_preonic_grid',
				comment_preview = { position = 'none' },
				layout = { '_ x x x x x' },
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats a complex design', function()
			local T = testy.snapshot('kinesis.c')

			local qmk = require('qmk')
			qmk.setup({
				name = 'LAYOUT_pretty',
				layout = {
					'x x x x x x x x x x x x x x x x x x',
					'x x x x x x _ _ _ _ _ _ x x x x x x',
					'x x x x x x _ _ _ _ _ _ x x x x x x',
					'x x x x x x _ _ _ _ _ _ x x x x x x',
					'x x x x x x _ _ _ _ _ _ x x x x x x',
					'_ x x x x _ _ _ _ _ _ _ _ x x x x _',
					'_ _ _ _ _ x x _ _ _ _ x x _ _ _ _ _',
					'_ _ _ _ _ _ x _ _ _ _ x _ _ _ _ _ _',
					'_ _ _ _ x x x _ _ _ _ x x x _ _ _ _',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats zmk keymaps', function()
			local T = testy.snapshot('dactyl.keymap', 'zmk')

			local qmk = require('qmk')
			qmk.setup({
				name = 'meh',
				variant = 'zmk',
				comment_preview = { position = 'top' },
				layout = {
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'_ _ _ _ _ x x _ _ _ _ _',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats zmk keymaps', function()
			local T = testy.snapshot('dactyl-bottom.keymap', 'zmk')

			local qmk = require('qmk')
			qmk.setup({
				name = 'meh',
				variant = 'zmk',
				comment_preview = { position = 'bottom' },
				layout = {
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'_ _ _ _ _ x x _ _ _ _ _',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats inline config', function()
			local T = testy.snapshot('inline_config.c', 'qmk')

			local qmk = require('qmk')
			qmk.setup({
				name = 'MY_LAYOUT',
				layout = {
					'x x x',
					'x x _',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)

		it('formats inline zmk keymaps', function()
			local T = testy.snapshot('dactyl_inline.keymap', 'zmk')

			local qmk = require('qmk')
			qmk.setup({
				name = 'meh',
				variant = 'zmk',
				comment_preview = { position = 'top' },
				layout = {
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'x x x x x x x x x x x x',
					'_ _ _ _ _ x x _ _ _ _ _',
				},
			})
			qmk.format(T.buff)

			assert.combinators.match(T.expected, T.buff_content())
		end)
	end)
end)
