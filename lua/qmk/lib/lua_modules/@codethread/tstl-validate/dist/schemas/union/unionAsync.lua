local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local getIssue = ____index.getIssue
--- Creates an async union schema.
-- 
-- @param union The union schema.
-- @param error The error message.
-- @returns An async union schema.
function ____exports.unionAsync(union, ____error)
    return {
        schema = "union",
        union = union,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                local issues
                local output
                for ____, schema in ipairs(union) do
                    local result = __TS__Await(schema:_parse(input, info))
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
                return ____awaiter_resolve(
                    nil,
                    output and ({output = output[1]}) or ({issues = {getIssue(info, {
                        reason = "type",
                        validation = "union",
                        message = ____error or "Invalid type, expected union",
                        input = input,
                        issues = issues
                    })}})
                )
            end)
        end
    }
end
return ____exports
