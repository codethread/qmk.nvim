--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation functions that validates the value of a string or number.
-- 
-- @param requirement The value.
-- @param error The error message.
-- @returns A validation function.
function ____exports.value(requirement, ____error)
    return function(input, info)
        if input ~= requirement then
            return {issues = {getIssue(info, {validation = "value", message = ____error or "Invalid value", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
