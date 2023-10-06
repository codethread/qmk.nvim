--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a non optional schema.
-- 
-- @param wrapped The wrapped schema.
-- @param error The error message.
-- @returns A non optional schema.
function ____exports.nonOptional(wrapped, ____error)
    return {
        schema = "non_optional",
        wrapped = wrapped,
        async = false,
        _parse = function(self, input, info)
            if input == nil then
                return {issues = {getIssue(info, {reason = "type", validation = "non_optional", message = ____error or "Invalid type, expected non_optional", input = input})}}
            end
            return wrapped:_parse(input, info)
        end
    }
end
return ____exports
