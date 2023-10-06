--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation function that checks the value for equality.
-- 
-- @param requirement The required value.
-- @param error The error message.
-- @returns A validation function.
function ____exports.equal(requirement, ____error)
    return function(input, info)
        if input ~= requirement then
            return {issues = {getIssue(info, {validation = "equal", message = ____error or "Invalid input", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
