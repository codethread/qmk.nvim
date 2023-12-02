local visitor = require('qmk.parse.visitor').visitor
local parse_query = require('qmk.parse.visitor').parse_query

local M = {}

---look through the keymap file and find all layouts, capturing
---the keymap name and a list of all keys for formatting
---@return Query
local function keymap_query_for(name)
	return parse_query('c', [[
(initializer_pair
	designator: (subscript_designator [(number_literal) (identifier)] @keymap_name)
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

M.key_ids = {
	key = 'key',
}

---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
function M.key_visitor(root, visitors) --
	---get all individual keys inside a layout
	---@type Query
	local key_query = parse_query(
		'c',
		[[
(initializer_pair
	value: (call_expression
	arguments: (argument_list [(identifier) (call_expression)] @key)))
	]]
	)
	visitor(key_query, root, visitors)
end

M.declaration_ids = {
	declaration = 'declaration',
}

---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
function M.declaration_visitor(root, visitors) --
	---get the entire keymap declaration
	---the intention is to use this for identifying the start and end
	---@type Query
	local keymap_declaration_query = parse_query(
		'c',
		[[
(init_declarator
    declarator: (array_declarator
        declarator: (array_declarator
            declarator: (array_declarator
                declarator: (identifier) @id (#eq? @id "keymaps"))))
    value: (initializer_list) @declaration)
]]
	)
	visitor(keymap_declaration_query, root, visitors)
end

---@param root tsnode
---@param visitors table<string, fun(node: tsnode): nil>
function M.comment_visitor(root, visitors)
	visitor(parse_query('c', [[(comment) @comment]]), root, visitors)
end

return M
