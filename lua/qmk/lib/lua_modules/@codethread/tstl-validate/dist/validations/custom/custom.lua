--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a custom validation function.
-- 
-- @param requirement The validation function.
-- @param error The error message.
-- @returns A validation function.
function ____exports.custom(requirement, ____error)
    return function(input, info)
        if not requirement(input) then
            return {issues = {getIssue(info, {validation = "custom", message = ____error or "Invalid input", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
