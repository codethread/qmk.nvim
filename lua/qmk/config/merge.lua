local key_map = require('qmk.config.key_map')
local parse = require('qmk.config.parse')

---@param options qmk.Config
---@param inline_config qmk.InlineConfig
---@return qmk.Config
local function merge_configs(options, inline_config)
	if inline_config.layout then
		options.layout = parse.parse_layout(inline_config.layout)
	end

	if inline_config.comment_preview then
		options.comment_preview.position = inline_config.comment_preview.position
			or options.comment_preview.position

		if inline_config.comment_preview.symbols then
			vim.tbl_extend(
				'force',
				options.comment_preview.symbols,
				inline_config.comment_preview.symbols
			)
		end

		if inline_config.comment_preview.keymap_overrides then
			-- TODO: need to still sort
			local sorted = key_map.sort(inline_config.comment_preview.keymap_overrides)
			options.comment_preview.keymap_overrides =
				vim.list_extend(sorted, options.comment_preview.keymap_overrides)
		end
	end

	return options
end

return merge_configs
