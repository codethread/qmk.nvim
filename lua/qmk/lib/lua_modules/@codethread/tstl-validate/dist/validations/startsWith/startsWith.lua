local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation functions that validates the start of a string.
-- 
-- @param requirement The start string.
-- @param error The error message.
-- @returns A validation function.
function ____exports.startsWith(requirement, ____error)
    return function(input, info)
        if not __TS__StringStartsWith(input, requirement) then
            return {issues = {getIssue(info, {validation = "starts_with", message = ____error or "Invalid start", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
