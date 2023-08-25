--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Returns the parse info of a path.
-- 
-- @param info The parse info.
-- @param pathItem The path item.
-- @returns The parse info.
function ____exports.getPathInfo(info, path, origin)
    if origin == nil then
        origin = "value"
    end
    return {origin = origin, path = path, abortEarly = info and info.abortEarly, abortPipeEarly = info and info.abortPipeEarly}
end
return ____exports
