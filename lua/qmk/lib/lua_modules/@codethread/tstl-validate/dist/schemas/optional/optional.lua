--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a optional schema.
-- 
-- @param wrapped The wrapped schema.
-- @returns A optional schema.
function ____exports.optional(wrapped)
    return {
        schema = "optional",
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
