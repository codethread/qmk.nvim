--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a transformation function that converts all the alphabetic
-- characters in a string to lowercase.
-- 
-- @returns A transformation function.
function ____exports.toLowerCase()
    return function(input) return {output = string.lower(input)} end
end
return ____exports
