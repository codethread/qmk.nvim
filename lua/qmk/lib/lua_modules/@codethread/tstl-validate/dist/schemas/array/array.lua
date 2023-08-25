local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
--- Creates a array schema.
-- 
-- @param item The item schema.
-- @param pipe A validation and transformation pipe.
-- @returns A array schema.
-- @param item The item schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A array schema.
function ____exports.array(item, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    return {
        schema = "array",
        array = {item = item},
        async = false,
        _parse = function(self, input, info)
            if not __TS__ArrayIsArray(input) then
                return {issues = {getIssue(info, {reason = "type", validation = "list", message = ____error or "Invalid type", input = input})}}
            end
            local issues
            local output = {}
            do
                local index = 0
                while index < #input do
                    local value = input[index + 1]
                    local result = item:_parse(
                        value,
                        getPathInfo(
                            info,
                            getPath(info and info.path, {schema = "array", input = input, key = index, value = value})
                        )
                    )
                    if result.issues then
                        if issues then
                            for ____, issue in ipairs(result.issues) do
                                issues[#issues + 1] = issue
                            end
                        else
                            issues = result.issues
                        end
                        if info and info.abortEarly then
                            break
                        end
                    else
                        output[#output + 1] = result.output
                    end
                    index = index + 1
                end
            end
            return issues and ({issues = issues}) or executePipe(
                output,
                pipe,
                getPipeInfo(info, "array")
            )
        end
    }
end
return ____exports
