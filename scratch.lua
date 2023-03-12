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

local s = { bar = 'world' }
s.foo = 'hello'
vim.pretty_print(s)
