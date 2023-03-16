local config = require 'qmk.config'
local format = require 'qmk.format'
local utils = require 'qmk.utils'

local qmk = {}
local configured_warning = 'QMK plugin is not configured. Please call qmk.setup() first'

-- setup QMK plugin
-- creates user commands and autocmds to autoformat
---@param options qmk.UserConfig
function qmk.setup(options)
	local ok, config_or_error = pcall(config.parse, options)
	if not ok then
		vim.notify(config_or_error, vim.log.levels.ERROR)
		return
	end
	qmk.options = config_or_error

	vim.api.nvim_create_user_command('QMKFormat', function()
		utils.safe_call(function() format(qmk.options) end)
	end, { desc = 'Format all keymaps in buffer' })

	-- vim.api.nvim_create_user_command(
	-- 	'QMKDisplay',
	-- 	function() format(qmk.options) end,
	-- 	{ desc = 'Display keymaps in a floating window' }
	-- )

	if config_or_error.auto_format_pattern then
		vim.api.nvim_create_autocmd('BufWritePre', {
			desc = 'Format keymap',
			group = vim.api.nvim_create_augroup('QMK', {}),
			pattern = qmk.options.auto_format_pattern,
			callback = function()
				utils.safe_call(function() format(qmk.options) end)
			end,
		})
	end
end

function qmk.is_configured() return qmk.options ~= nil end

-- format all QMK keymaps in the current buffer
---@param buf? buffer number
function qmk.format(buf)
	if not qmk.is_configured() then
		vim.notify(configured_warning, vim.log.levels.WARN)
		return
	end

	utils.safe_call(function() format(qmk.options, buf) end)
end

-- display all QMK keymaps in a floating window
---@param buf? buffer number
-- function qmk.display()
-- 	if not qmk.is_configured() then
-- 		vim.notify(configured_warning, vim.log.levels.WARN)
-- 		return
-- 	end

-- 	vim.notify 'WIP'
-- end

qmk.options = nil
return qmk
