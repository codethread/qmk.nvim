local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a async custom validation function.
-- 
-- @param requirement The async validation function.
-- @param error The error message.
-- @returns A async validation function.
function ____exports.customAsync(requirement, ____error)
    return function(input, info)
        return __TS__AsyncAwaiter(function(____awaiter_resolve)
            if not __TS__Await(requirement(input)) then
                return ____awaiter_resolve(
                    nil,
                    {issues = {getIssue(info, {validation = "custom", message = ____error or "Invalid input", input = input})}}
                )
            end
            return ____awaiter_resolve(nil, {output = input})
        end)
    end
end
return ____exports
