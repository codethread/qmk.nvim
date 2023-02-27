
---@class tsnode
---@field range fun(): number, number, number, number Get the range of the node. Return four values: the row, column of the start position, then the row, column of the end position.

-- tsnode:parent()                                         *tsnode:parent()*
--     Get the node's immediate parent.

-- tsnode:next_sibling()                                   *tsnode:next_sibling()*
--     Get the node's next sibling.

-- tsnode:prev_sibling()                                   *tsnode:prev_sibling()*
--     Get the node's previous sibling.

-- tsnode:next_named_sibling()                       *tsnode:next_named_sibling()*
--     Get the node's next named sibling.

-- tsnode:prev_named_sibling()                       *tsnode:prev_named_sibling()*
--     Get the node's previous named sibling.

-- tsnode:iter_children()                                 *tsnode:iter_children()*
--     Iterates over all the direct children of {tsnode}, regardless of whether
--     they are named or not.
--     Returns the child node plus the eventual field name corresponding to this
--     child node.

-- tsnode:field({name})                                    *tsnode:field()*
--     Returns a table of the nodes corresponding to the {name} field.

-- tsnode:child_count()                                    *tsnode:child_count()*
--     Get the node's number of children.

-- tsnode:child({index})                                   *tsnode:child()*
--     Get the node's child at the given {index}, where zero represents the first
--     child.

-- tsnode:named_child_count()                         *tsnode:named_child_count()*
--     Get the node's number of named children.

-- tsnode:named_child({index})                              *tsnode:named_child()*
--     Get the node's named child at the given {index}, where zero represents the
--     first named child.

-- tsnode:start()                                          *tsnode:start()*
--     Get the node's start position. Return three values: the row, column and
--     total byte count (all zero-based).

-- tsnode:end_()                                           *tsnode:end_()*
--     Get the node's end position. Return three values: the row, column and
--     total byte count (all zero-based).

-- tsnode:range()                                          *tsnode:range()*
--     Get the range of the node. Return four values: the row, column of the
--     start position, then the row, column of the end position.

-- tsnode:type()                                           *tsnode:type()*
--     Get the node's type as a string.

-- tsnode:symbol()                                         *tsnode:symbol()*
--     Get the node's type as a numerical id.

-- tsnode:named()                                          *tsnode:named()*
--     Check if the node is named. Named nodes correspond to named rules in the
--     grammar, whereas anonymous nodes correspond to string literals in the
--     grammar.

-- tsnode:missing()                                        *tsnode:missing()*
--     Check if the node is missing. Missing nodes are inserted by the parser in
--     order to recover from certain kinds of syntax errors.

-- tsnode:has_error()                                      *tsnode:has_error()*
--     Check if the node is a syntax error or contains any syntax errors.

-- tsnode:sexpr()                                          *tsnode:sexpr()*
--     Get an S-expression representing the node as a string.

-- tsnode:id()                                             *tsnode:id()*
--     Get an unique identifier for the node inside its own tree.

--     No guarantees are made about this identifier's internal representation,
--     except for being a primitive Lua type with value equality (so not a
--     table). Presently it is a (non-printable) string.

--     Note: The `id` is not guaranteed to be unique for nodes from different
--     trees.

--                                                 *tsnode:descendant_for_range()*
-- tsnode:descendant_for_range({start_row}, {start_col}, {end_row}, {end_col})
--     Get the smallest node within this node that spans the given range of (row,
--     column) positions

--                                           *tsnode:named_descendant_for_range()*
-- tsnode:named_descendant_for_range({start_row}, {start_col}, {end_row}, {end_col})
--     Get the smallest named node within this node that spans the given range of
--     (row, column) positions
