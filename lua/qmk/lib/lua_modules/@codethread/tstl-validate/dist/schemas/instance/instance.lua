local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates an instance schema.
-- 
-- @param of The class of the instance.
-- @param pipe A validation and transformation pipe.
-- @returns An instance schema.
-- @param of The class of the instance.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An instance schema.
function ____exports.instance(of, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "instance",
        class = of,
        async = false,
        _parse = function(self, input, info)
            if not __TS__InstanceOf(input, of) then
                return {issues = {getIssue(info, {reason = "type", validation = "instance", message = ____error or "Invalid type, expected instance", input = input})}}
            end
            return executePipe(
                input,
                pipe,
                getPipeInfo(info, "instance")
            )
        end
    }
end
return ____exports
