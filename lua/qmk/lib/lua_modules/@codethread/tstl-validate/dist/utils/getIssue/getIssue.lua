--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Returns the final issue data.
-- 
-- @param info The parse info.
-- @param issue The issue data.
-- @returns The issue data.
-- @param info The validate info.
-- @param issue The issue data.
-- @returns The issue data.
function ____exports.getIssue(info, issue)
    return {
        reason = info and info.reason or issue.reason,
        validation = issue.validation,
        origin = info and info.origin or "value",
        message = issue.message,
        input = issue.input,
        path = info and info.path,
        issues = issue.issues,
        abortEarly = info and info.abortEarly,
        abortPipeEarly = info and info.abortPipeEarly
    }
end
return ____exports
