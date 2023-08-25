local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation functions that validates the end of a string.
-- 
-- @param requirement The end string.
-- @param error The error message.
-- @returns A validation function.
function ____exports.endsWith(requirement, ____error)
    return function(input, info)
        if not __TS__StringEndsWith(input, requirement) then
            return {issues = {getIssue(info, {validation = "ends_with", message = ____error or "Invalid end", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
