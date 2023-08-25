--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a nullable schema.
-- 
-- @param wrapped The wrapped schema.
-- @returns A nullable schema.
function ____exports.nullable(wrapped)
    return {
        schema = "nullable",
        wrapped = wrapped,
        async = false,
        _parse = function(self, input, info)
            if input == nil then
                return {output = input}
            end
            return wrapped:_parse(input, info)
        end
    }
end
return ____exports
