--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a literal schema.
-- 
-- @param literal The literal value.
-- @param error The error message.
-- @returns A literal schema.
function ____exports.literal(literal, ____error)
    return {
        schema = "literal",
        literal = literal,
        async = false,
        _parse = function(self, input, info)
            if input ~= literal then
                return {issues = {getIssue(info, {reason = "type", validation = "literal", message = ____error or "Invalid type, expected literal", input = input})}}
            end
            return {output = input}
        end
    }
end
return ____exports
