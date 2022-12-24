local format = require 'qmk.format'

local qmk = {}

local function with_defaults(options)
	return {
		rows = options.rows,
		columns = options.columns,
		pattern = options.pattern or '*keymap.c',
	}
end

-- This function is supposed to be called explicitly by users to configure this
-- plugin
function qmk.setup(options)
	qmk.options = with_defaults(options)

	vim.api.nvim_create_user_command('QMKFormat', function() format(qmk.options) end, {})

	vim.api.nvim_create_autocmd('BufWritePre', {
		desc = 'Format keymap',
		group = vim.api.nvim_create_augroup('QMK', {}),
		pattern = qmk.options.pattern,
		callback = function() format(qmk.options) end,
	})
end

function qmk.is_configured() return qmk.options ~= nil end

-- This is a function that will be used outside this plugin code.
-- Think of it as a public API
function qmk.format(buf)
	if not qmk.is_configured() then return end

	format(qmk.options, buf)
end

qmk.options = nil
return qmk
