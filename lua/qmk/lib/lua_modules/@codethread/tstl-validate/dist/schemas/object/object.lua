local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
--- Creates an object schema.
-- 
-- @param object The object schema.
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
-- @param object The object schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An object schema.
function ____exports.object(object, arg2, arg3)
    local ____getErrorAndPipe_result_0 = getErrorAndPipe(arg2, arg3)
    local ____error = ____getErrorAndPipe_result_0.error
    local pipe = ____getErrorAndPipe_result_0.pipe
    local cachedEntries
    return {
        schema = "object",
        object = object,
        async = false,
        _parse = function(self, input, info)
            if not input or type(input) ~= "table" or __TS__ArrayIsArray(input) then
                return {issues = {getIssue(info, {reason = "type", validation = "table", message = ____error or "Invalid type", input = input})}}
            end
            cachedEntries = cachedEntries or __TS__ObjectEntries(object)
            local issues
            local output = {}
            for ____, objectEntry in ipairs(cachedEntries) do
                local key = objectEntry[1]
                local value = input[key]
                local result = objectEntry[2]:_parse(
                    value,
                    getPathInfo(
                        info,
                        getPath(info and info.path, {schema = "object", input = input, key = key, value = value})
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
                    output[key] = result.output
                end
            end
            return issues and ({issues = issues}) or executePipe(
                output,
                pipe,
                getPipeInfo(info, "object")
            )
        end
    }
end
return ____exports
