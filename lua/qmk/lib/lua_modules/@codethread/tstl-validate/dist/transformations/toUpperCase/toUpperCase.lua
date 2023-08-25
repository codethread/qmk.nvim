--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a transformation function that converts all the alphabetic
-- characters in a string to uppercase.
-- 
-- @returns A transformation function.
function ____exports.toUpperCase()
    return function(input) return {output = string.upper(input)} end
end
return ____exports
