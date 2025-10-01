local ts = vim.treesitter

---@return qmk.InlineConfig | nil
local function get_inline_config(visitor, root, content)
	local config = nil
	local comments = {}

	visitor(root, {
		comment = function(node)
			local comment = ts.get_node_text(node, content)
			table.insert(comments, comment)
		end,
	})

	local comment = table.concat(comments, '\n')

	if string.match(comment, 'qmk:json:start') then
		local lines = {}
		local started = nil
		local fin = nil

		for s in comment:gmatch('[^\r\n]+') do
			if string.match(s, 'qmk:json:start') then
				started = true
			elseif string.match(s, 'qmk:json:end') then
				fin = true
			elseif started and not fin then
				table.insert(lines, s)
			end
		end

		local ok, json = pcall(vim.json.decode, table.concat(lines))

		if not ok then
			error(
				'could not parse inline config as JSON, best to copy/paste to an online JSON viewer'
			)
		end

		config = json
	end

	return config
end

return get_inline_config
