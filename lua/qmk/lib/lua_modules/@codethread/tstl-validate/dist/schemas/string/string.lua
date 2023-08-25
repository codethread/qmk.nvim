--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates a string schema.
-- 
-- @param pipe A validation and transformation pipe.
-- @returns A string schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A string schema.
function ____exports.string(arg1, arg2)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg1, arg2)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "string",
        async = false,
        _parse = function(self, input, info)
            if type(input) ~= "string" then
                return {issues = {getIssue(info, {reason = "type", validation = "string", message = ____error or "Invalid type, expected string", input = input})}}
            end
            return executePipe(
                input,
                pipe,
                getPipeInfo(info, "string")
            )
        end
    }
end
return ____exports
