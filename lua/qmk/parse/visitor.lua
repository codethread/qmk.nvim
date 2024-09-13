local ts = vim.treesitter

---@param query vim.treesitter.Query
---@param root TSNode
---@param visitors table<string, fun(node: TSNode): nil>
---@param content? string
---@param start? integer,
---@param final? integer
local function visitor(query, root, visitors, content, start, final)
	---@diagnostic disable-next-line: param-type-mismatch
	for id, n in query:iter_captures(root, content, start, final) do
		local capture_name = query.captures[id]
		local node = n

		if visitors[capture_name] then
			visitors[capture_name](node)
		end
	end
end

return {
	visitor = visitor,
	parse_query = vim.version().minor < 9 and ts.parse_query or ts.query.parse,
}
