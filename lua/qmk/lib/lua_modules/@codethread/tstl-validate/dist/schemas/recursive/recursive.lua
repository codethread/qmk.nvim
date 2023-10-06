--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a recursive schema.
-- 
-- @param getter The schema getter.
-- @returns A recursive schema.
function ____exports.recursive(getter)
    return {
        schema = "recursive",
        getter = getter,
        async = false,
        _parse = function(self, input, info)
            return getter():_parse(input, info)
        end
    }
end
return ____exports
