--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Returns the pipe info.
-- 
-- @param info The parse info.
-- @param reason The issue reason.
-- @returns The pipe info.
function ____exports.getPipeInfo(info, reason)
    return {
        origin = info and info.origin,
        path = info and info.path,
        abortEarly = info and info.abortEarly,
        abortPipeEarly = info and info.abortPipeEarly,
        reason = reason
    }
end
return ____exports
