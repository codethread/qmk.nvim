local visitor = require('qmk.parse.visitor').visitor
local parse_query = require('qmk.parse.visitor').parse_query

local M = {}

M.keymap_ids = {
	layer_name = 'layer_name',
	bindings = 'bindings',
	final = 'final',
}

---@param root TSNode
---@param content string
---@param visitors table<string, fun(node: TSNode): nil>
function M.keymap_visitor(root, content, visitors)
	--TODO: pull out and memo later

	---look through the whole file and find all layouts
	---including their names
	---zmk is a little more dynamic than qmk, so we just grab
	---everything in the bindings node and iterate through the
	---children
	---@type vim.treesitter.Query
	local keymap_query = parse_query(
		'devicetree',
		[[
(node
    name: (identifier) @_nodeid (#eq? @_nodeid keymap)
    (node
        name: (identifier) @layer_name
        (property
            name: (identifier) @_propid (#eq? @_propid bindings)
            value: (_ (">" @final)) @bindings)))
]]
	)

	visitor(keymap_query, root, visitors, content)
end

---@param root TSNode
---@param visitors table<string, fun(node: TSNode): nil>
function M.comment_visitor(root, visitors)
	visitor(parse_query('devicetree', [[(comment) @comment]]), root, visitors)
end

return M
