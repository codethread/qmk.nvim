local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Coerces the input of a schema to match the required type.
-- 
-- @param schema The affected schema.
-- @param action The coerceation action.
-- @returns The passed schema.
function ____exports.coerce(schema, action)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            return schema:_parse(
                action(input),
                info
            )
        end}
    )
end
return ____exports
