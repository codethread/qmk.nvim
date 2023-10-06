--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPipeInfo = ____index.getPipeInfo
--- Creates a special schema.
-- 
-- @param check The type check function.
-- @param pipe A validation and transformation pipe.
-- @returns A special schema.
-- @param check The type check function.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A special schema.
function ____exports.special(check, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "special",
        async = false,
        _parse = function(self, input, info)
            if not check(input) then
                return {issues = {getIssue(info, {reason = "type", validation = "special", message = ____error or "Invalid type, expected special", input = input})}}
            end
            return executePipe(
                input,
                pipe,
                getPipeInfo(info, "special")
            )
        end
    }
end
return ____exports
