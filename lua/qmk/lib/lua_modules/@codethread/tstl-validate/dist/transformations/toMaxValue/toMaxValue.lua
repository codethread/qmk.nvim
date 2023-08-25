--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a transformation function that sets a string, number or date to a
-- maximum value.
-- 
-- @param requirement The maximum value.
-- @returns A transformation function.
function ____exports.toMaxValue(requirement)
    return function(input) return {output = input > requirement and requirement or input} end
end
return ____exports
