--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Returns the current path.
-- 
-- @param info The parse info.
-- @param key The current key.
-- @returns The current path.
function ____exports.getPath(prevPath, pathItem)
    local path = {}
    if prevPath then
        for ____, pathItem in ipairs(prevPath) do
            path[#path + 1] = pathItem
        end
    end
    path[#path + 1] = pathItem
    return path
end
return ____exports
