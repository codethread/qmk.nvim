local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates an async non optional schema.
-- 
-- @param wrapped The wrapped schema.
-- @param error The error message.
-- @returns An async non optional schema.
function ____exports.nonOptionalAsync(wrapped, ____error)
    return {
        schema = "non_optional",
        wrapped = wrapped,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if input == nil then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "non_optional", message = ____error or "Invalid type, expected non_optional", input = input})}}
                    )
                end
                return ____awaiter_resolve(
                    nil,
                    wrapped:_parse(input, info)
                )
            end)
        end
    }
end
return ____exports
