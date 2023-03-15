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

local n = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
vim.pretty_print(vim.list_slice(n, 2))
