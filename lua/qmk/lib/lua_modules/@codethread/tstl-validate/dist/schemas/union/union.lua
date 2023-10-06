--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates a union schema.
-- 
-- @param union The union schema.
-- @param error The error message.
-- @returns A union schema.
function ____exports.union(union, ____error)
    return {
        schema = "union",
        union = union,
        async = false,
        _parse = function(self, input, info)
            local issues
            local output
            for ____, schema in ipairs(union) do
                local result = schema:_parse(input, info)
                if result.issues then
                    if issues then
                        for ____, issue in ipairs(result.issues) do
                            issues[#issues + 1] = issue
                        end
                    else
                        issues = result.issues
                    end
                else
                    output = {result.output}
                    break
                end
            end
            return output and ({output = output[1]}) or ({issues = {getIssue(info, {
                reason = "type",
                validation = "union",
                message = ____error or "Invalid type, expected union",
                input = input,
                issues = issues
            })}})
        end
    }
end
return ____exports
