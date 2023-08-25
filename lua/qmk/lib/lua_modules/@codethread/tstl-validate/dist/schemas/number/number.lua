--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates a number schema.
-- 
-- @param pipe A validation and transformation pipe.
-- @returns A number schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A number schema.
function ____exports.number(arg1, arg2)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg1, arg2)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "number",
        async = false,
        _parse = function(self, input, info)
            if type(input) ~= "number" then
                return {issues = {getIssue(info, {reason = "type", validation = "number", message = ____error or "Invalid type, expected number", input = input})}}
            end
            return executePipe(
                input,
                pipe,
                getPipeInfo(info, "number")
            )
        end
    }
end
return ____exports
