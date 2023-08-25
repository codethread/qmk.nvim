--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation function that validates whether a number is a multiple.
-- 
-- @param requirement The divisor.
-- @param error The error message.
-- @returns A validation function.
function ____exports.multipleOf(requirement, ____error)
    return function(input, info)
        if input % requirement ~= 0 then
            return {issues = {getIssue(info, {validation = "multipleOf", message = ____error or "Invalid multiple", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
