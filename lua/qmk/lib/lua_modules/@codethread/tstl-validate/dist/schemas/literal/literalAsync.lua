local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates an async literal schema.
-- 
-- @param literal The literal value.
-- @param error The error message.
-- @returns An async literal schema.
function ____exports.literalAsync(literal, ____error)
    return {
        schema = "literal",
        literal = literal,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if input ~= literal then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "literal", message = ____error or "Invalid type, expected literal", input = input})}}
                    )
                end
                return ____awaiter_resolve(nil, {output = input})
            end)
        end
    }
end
return ____exports
