local ts = vim.treesitter

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

		if visitors[capture_name] then visitors[capture_name](node) end
	end
end

local M = {}

---look through the keymap file and find all layouts, capturing
---the keymap name and a list of all keys for formatting
---@return Query
local function keymap_query_for(name)
	return ts.parse_query('c', [[
(initializer_pair
    designator: (subscript_designator (identifier) @keymap_name)
    value: (call_expression
             function: (identifier) @id (#eq? @id ]] .. name .. [[)
             arguments: (argument_list ")" @final))) @key_list
]])
end

M.keymap_ids = {
	keymap_name = 'keymap_name',
	key_list = 'key_list',
	final = 'final',
}

---@param name string
---@param root tsnode
---@param content string
---@param visitors table<string, fun(node: tsnode): nil>
function M.keymap_visitor(name, root, content, visitors)
	local query = keymap_query_for(name)
	visitor(query, root, visitors, content)
end

---get all individual keys inside a layout
---@type Query
local key_query = ts.parse_query(
	'c',
	[[
(initializer_pair
	value: (call_expression
	arguments: (argument_list [(identifier) (call_expression)] @key)))
	]]
)

M.key_ids = {
	key = 'key',
}

---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
function M.key_visitor(root, visitors) --
	visitor(key_query, root, visitors)
end

M.declaration_ids = {
	declaration = 'declaration',
}

---get the entire keymap declaration
---the intention is to use this for identifying the start and end
---@type Query
local keymap_declaration_query = ts.parse_query(
	'c',
	[[
(init_declarator
    declarator: (array_declarator
        declarator: (array_declarator
            declarator: (array_declarator
                declarator: (identifier))))
    value: (initializer_list) @declaration)
]]
)

---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
function M.declaration_visitor(root, visitors) --
	visitor(keymap_declaration_query, root, visitors)
end

return M
