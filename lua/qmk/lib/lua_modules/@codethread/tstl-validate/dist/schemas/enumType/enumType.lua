local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayJoin = ____lualib.__TS__ArrayJoin
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a enum schema.
-- 
-- @param enumValue The enum value.
-- @param error The error message.
-- @returns A enum schema.
function ____exports.enumType(enumValue, ____error)
    return {
        schema = "enum",
        enum = enumValue,
        async = false,
        _parse = function(self, input, info)
            if not __TS__ArrayIncludes(enumValue, input) then
                return {issues = {getIssue(
                    info,
                    {
                        reason = "type",
                        validation = "enum",
                        message = ____error or "Invalid type, expected one of " .. __TS__ArrayJoin(enumValue, ", "),
                        input = input
                    }
                )}}
            end
            return {output = input}
        end
    }
end
return ____exports
