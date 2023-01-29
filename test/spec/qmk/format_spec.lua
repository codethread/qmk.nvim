require 'matcher_combinators.luassert'
local format = require 'qmk.format'

-- print(format)
describe('greeting', function()
	it('works!', function()
		-- assert.are.same(5, 5)
		assert.combinators.match('Gabo', format 'Gabo')
	end)
end)
