local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates an async enum schema.
-- 
-- @param enumValue The enum value.
-- @param error The error message.
-- @returns An async enum schema.
function ____exports.enumTypeAsync(enumValue, ____error)
    return {
        schema = "enum",
        enum = enumValue,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if not __TS__ArrayIncludes(enumValue, input) then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(
                            info,
                            {
                                reason = "type",
                                validation = "enum",
                                message = ____error or "Invalid type, expected one of " .. __TS__ArrayJoin(enumValue, ", "),
                                input = input
                            }
                        )}}
                    )
                end
                return ____awaiter_resolve(nil, {output = input})
            end)
        end
    }
end
return ____exports
