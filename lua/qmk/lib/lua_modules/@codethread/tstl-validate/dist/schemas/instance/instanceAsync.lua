local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates an async instance schema.
-- 
-- @param of The class of the instance.
-- @param pipe A validation and transformation pipe.
-- @returns An async instance schema.
-- @param of The class of the instance.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async instance schema.
function ____exports.instanceAsync(of, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "instance",
        class = of,
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if not __TS__InstanceOf(input, of) then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "instance", message = ____error or "Invalid type, expected instance", input = input})}}
                    )
                end
                return ____awaiter_resolve(
                    nil,
                    executePipeAsync(
                        input,
                        pipe,
                        getPipeInfo(info, "instance")
                    )
                )
            end)
        end
    }
end
return ____exports
