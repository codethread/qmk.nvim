--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Creates a custom transformation function.
-- 
-- @param action The transform action.
-- @returns A transformation function.
function ____exports.toCustom(action)
    return function(input) return {output = action(input)} end
end
return ____exports
