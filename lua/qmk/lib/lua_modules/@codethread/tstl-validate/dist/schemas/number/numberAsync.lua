local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates an async number schema.
-- 
-- @param pipe A validation and transformation pipe.
-- @returns An async number schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async number schema.
function ____exports.numberAsync(arg1, arg2)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg1, arg2)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "number",
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if type(input) ~= "number" then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "number", message = ____error or "Invalid type, expected number", input = input})}}
                    )
                end
                return ____awaiter_resolve(
                    nil,
                    executePipeAsync(
                        input,
                        pipe,
                        getPipeInfo(info, "number")
                    )
                )
            end)
        end
    }
end
return ____exports
