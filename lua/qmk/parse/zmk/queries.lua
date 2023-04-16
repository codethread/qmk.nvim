local visitor = require('qmk.parse.visitor').visitor
local parse_query = require('qmk.parse.visitor').parse_query

local M = {}

---look through the whole file and find all layouts
---including their names
---zmk is a little more dynamic than qmk, so we just grab
---everything in the bindings node and iterate through the
---children
---@type Query
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

M.keymap_ids = {
	layer_name = 'layer_name',
	bindings = 'bindings',
	final = 'final',
}

---@param root tsnode
---@param content string
---@param visitors table<string, fun(node: tsnode): nil>
function M.keymap_visitor(root, content, visitors)
	visitor(keymap_query, root, visitors, content)
end

return M
