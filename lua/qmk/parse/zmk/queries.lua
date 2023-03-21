local ts = vim.treesitter

ts.parse_query(
	'dts',
	[[
(node
    name: (identifier) @nodeid (#eq? @nodeid keymap)
    (node
        name: (identifier) @layer_name
        (property
            name: (identifier) @propid (#eq? @propid bindings)
            value: (_ (_) @keys) @bindings)))
]]
)
