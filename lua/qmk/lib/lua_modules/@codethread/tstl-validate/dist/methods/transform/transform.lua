local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Adds a transformation step to a schema, which is executed at the end of
-- parsing and can change the output type.
-- 
-- @param schema The schema to be used.
-- @param action The transformation action.
-- @returns A transformed schema.
function ____exports.transform(schema, action)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            local result = schema:_parse(input, info)
            return result.issues and result or ({output = action(result.output)})
        end}
    )
end
return ____exports
