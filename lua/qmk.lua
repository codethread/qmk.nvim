local config = require('qmk.config')
local utils = require('qmk.utils')
local format = require('qmk.commands.format')

local qmk = {}
local configured_warning = 'QMK plugin is not configured. Please call qmk.setup() first'

-- setup QMK plugin
-- creates user commands and autocmds to autoformat
---@param options qmk.UserConfig
function qmk.setup(options)
	utils.timeout = options and options.timeout or 5000

	local ok, config_or_error = pcall(config.parse, options)
	if not ok then
		utils.notify(config_or_error)
		return
	end

	qmk.options = config_or_error

	vim.api.nvim_create_user_command('QMKFormat', function()
		qmk.format()
	end, { desc = 'Format all keymaps in buffer' })

	if config_or_error.auto_format_pattern then
		vim.api.nvim_create_autocmd('BufWritePre', {
			desc = 'Format keymap',
			group = vim.api.nvim_create_augroup('QMK', {}),
			pattern = qmk.options.auto_format_pattern,
			callback = function()
				qmk.format()
			end,
		})
	end
end

function qmk.is_configured()
	return qmk.options ~= nil
end

-- format all QMK keymaps in the current buffer
---@param buf? number buffer #default current
function qmk.format(buf)
	if not qmk.is_configured() then
		utils.notify(configured_warning)
		return
	end

	local ok, err = pcall(format, qmk.options, buf)
	if not ok then
		utils.notify(err)
	end
end

qmk.options = nil

return qmk
