---@class tsnode
---@field range fun(): number, number, number, number #Get the range of the node. Return four values: the row, column of the start position, then the row, column of the end position.

---@param query Query
---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
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

return { visitor = visitor }
