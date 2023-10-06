local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a strict async object schema that throws an error if an input
-- contains unknown keys.
-- 
-- @param schema A object schema.
-- @param error The error message.
-- @returns A strict object schema.
function ____exports.strictAsync(schema, ____error)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                local result = __TS__Await(schema:_parse(input, info))
                return ____awaiter_resolve(
                    nil,
                    not result.issues and #__TS__ObjectKeys(input) ~= #__TS__ObjectKeys(result.output) and ({issues = {getIssue(info, {reason = "object", validation = "strict", message = ____error or "Invalid keys", input = input})}}) or result
                )
            end)
        end}
    )
end
return ____exports
