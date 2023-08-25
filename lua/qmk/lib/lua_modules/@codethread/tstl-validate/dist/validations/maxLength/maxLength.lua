--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation functions that validates the length of a string or array.
-- 
-- @param requirement The maximum length.
-- @param error The error message.
-- @returns A validation function.
function ____exports.maxLength(requirement, ____error)
    return function(input, info)
        if #input > requirement then
            return {issues = {getIssue(
                info,
                {
                    validation = "max_length",
                    message = ____error or "Invalid length, expected less than " .. tostring(requirement),
                    input = input
                }
            )}}
        end
        return {output = input}
    end
end
return ____exports
