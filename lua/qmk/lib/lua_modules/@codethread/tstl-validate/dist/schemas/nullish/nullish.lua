--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a nullish schema.
-- 
-- @param wrapped The wrapped schema.
-- @returns A nullish schema.
function ____exports.nullish(wrapped)
    return {
        schema = "nullish",
        wrapped = wrapped,
        async = false,
        _parse = function(self, input, info)
            if input == nil or input == nil then
                return {output = input}
            end
            return wrapped:_parse(input, info)
        end
    }
end
return ____exports
