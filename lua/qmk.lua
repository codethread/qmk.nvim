local const = require 'qmk.const'
local config = require 'qmk.config'
local format = require 'qmk.format'

local qmk = {}

---@param options qmk.UserConfig
---@return qmk.Config
local function with_defaults(options)
	if not options.name or not options.layout then error 'name and layout are required' end

	return vim.tbl_deep_extend('force', config.default_config, options)
end

--- setup QMK plugin
---@param options qmk.UserConfig
function qmk.setup(options)
	qmk.options = with_defaults(options)

	vim.api.nvim_create_user_command(
		'QMKFormat',
		function() format(qmk.options) end,
		{ desc = 'Format all keymaps in buffer' }
	)
	vim.api.nvim_create_user_command(
		'QMKDisplay',
		function() format(qmk.options) end,
		{ desc = 'Display keymaps in a floating window' }
	)

	if options.auto_format_pattern then
		vim.api.nvim_create_autocmd('BufWritePre', {
			desc = 'Format keymap',
			group = vim.api.nvim_create_augroup('QMK', {}),
			pattern = qmk.options.auto_format_pattern,
			callback = function() format(qmk.options) end,
		})
	end
end

function qmk.is_configured() return qmk.options ~= nil end

-- format all QMK keymaps in the current buffer
---@param buf? buffer number
function qmk.format(buf)
	if not qmk.is_configured() then
		vim.notify(const.configured_warning, vim.log.levels.WARN)
		return
	end

	format(qmk.options, buf)
end

qmk.options = nil
return qmk
