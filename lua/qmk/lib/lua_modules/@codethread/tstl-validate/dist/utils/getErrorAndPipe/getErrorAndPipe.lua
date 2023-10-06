--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Returns error and pipe from dynamic arguments.
-- 
-- @param arg1 First argument.
-- @param arg2 Second argument.
-- @returns The error and pipe.
function ____exports.getErrorAndPipe(arg1, arg2)
    if not arg1 or type(arg1) == "string" then
        local pipe = arg2 or ({})
        return {error = arg1, pipe = pipe}
    else
        local pipe = arg1 or ({})
        return {error = nil, pipe = pipe}
    end
end
return ____exports
