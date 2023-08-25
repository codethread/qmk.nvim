local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a strict object schema that throws an error if an input contains
-- unknown keys.
-- 
-- @param schema A object schema.
-- @param error The error message.
-- @returns A strict object schema.
function ____exports.strict(schema, ____error)
    return __TS__ObjectAssign(
        {},
        schema,
        {_parse = function(self, input, info)
            local result = schema:_parse(input, info)
            if result.issues then
                return result
            end
            local iKeys = __TS__ObjectKeys(input)
            local rKeys = __TS__ObjectKeys(result.output)
            local newKeys = __TS__ArrayFilter(
                iKeys,
                function(____, key) return not __TS__ArrayIncludes(rKeys, key) end
            )
            return #newKeys > 0 and ({issues = {getIssue(
                info,
                {
                    reason = "object",
                    validation = "strict",
                    message = ____error or "Invalid keys: " .. table.concat(newKeys, ","),
                    input = input
                }
            )}}) or result
        end}
    )
end
return ____exports
