local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- Passes a default value to a schema in case of an undefined input.
-- 
-- @param schema The affected schema.
-- @param value The default value.
-- @returns The passed schema.
function ____exports.withDefault(schema, value)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            local ____schema_1 = schema
            local ____schema__parse_2 = schema._parse
            local ____temp_0
            if input == nil then
                ____temp_0 = value
            else
                ____temp_0 = input
            end
            return ____schema__parse_2(____schema_1, ____temp_0, info)
        end}
    )
end
--- See {@link withDefault}
-- 
-- @deprecated Function has been renamed to `withDefault`.
____exports.useDefault = ____exports.withDefault
return ____exports
