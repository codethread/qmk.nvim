--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a non nullable schema.
-- 
-- @param wrapped The wrapped schema.
-- @param error The error message.
-- @returns A non nullable schema.
function ____exports.nonNullable(wrapped, ____error)
    return {
        schema = "non_nullable",
        wrapped = wrapped,
        async = false,
        _parse = function(self, input, info)
            if input == nil then
                return {issues = {getIssue(info, {reason = "type", validation = "non_nullable", message = ____error or "Invalid type, expected non_nullable", input = input})}}
            end
            return wrapped:_parse(input, info)
        end
    }
end
return ____exports
