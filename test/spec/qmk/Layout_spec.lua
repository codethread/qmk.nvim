local Layout = require 'qmk.Layout'
local match = assert.combinators.match

describe('Layout', function()
	describe(':new', function()
		it('should create a new Layout instance', function()
			---@type qmk.UserLayout
			local user_layout = { { 'x' } }
			local layout = Layout:new(user_layout)
			match(layout.num_rows, 1)
			match(layout.num_cols, 1)
			match(layout.total_keys, 1)

			local res
			layout:for_rows(function(row)
				row:for_row(function(key) res = col end)
			end)
			match(res, 'simple')
		end)
	end)
end)
