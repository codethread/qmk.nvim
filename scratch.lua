-- require('qmk').setup {
-- 	name = 'LAYOUT_preonic_grid',
-- 	layout = {
-- 		'| x x x x x x x x x x x x',
-- 		'| x x x x x x x x x x x x',
-- 		'| x x x x x x x x x x x x',
-- 		'| x x x x x x x x x x x x',
-- 		'| x x x x x x x x x x x x',
-- 	},
-- }

function cond(table)
	for k, v in pairs(table) do
		if k then return v end
	end
end
local function foo(n)
	return cond {
		[n > 1] = 'a',
		[n > 2] = 'b',
		[n > 3] = 'c',
		[true] = 'd',
	}
end

print(foo(2))
