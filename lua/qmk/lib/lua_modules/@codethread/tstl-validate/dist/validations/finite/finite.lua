local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a validation function that validates whether a number is finite.
-- 
-- @param error The error message.
-- @returns A validation function.
function ____exports.finite(____error)
    return function(input, info)
        if not __TS__NumberIsFinite(input) then
            return {issues = {getIssue(info, {validation = "finite", message = ____error or "Invalid infinite number", input = input})}}
        end
        return {output = input}
    end
end
return ____exports
