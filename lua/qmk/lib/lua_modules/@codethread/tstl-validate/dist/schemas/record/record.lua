local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipe = ____index.executePipe
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.string.index")
local ____string = ____index.string
local ____values = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.record.values")
local BLOCKED_KEYS = ____values.BLOCKED_KEYS
--- Creates a record schema.
-- 
-- @param value The value schema.
-- @param pipe A validation and transformation pipe.
-- @returns A record schema.
-- @param value The value schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A record schema.
-- @param key The key schema.
-- @param value The value schema.
-- @param pipe A validation and transformation pipe.
-- @returns A record schema.
-- @param key The key schema.
-- @param value The value schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns A record schema.
function ____exports.record(arg1, arg2, arg3, arg4)
    local ____temp_0 = type(arg2) == "table" and not __TS__ArrayIsArray(arg2) and __TS__ObjectAssign(
        {key = arg1, value = arg2},
        getErrorAndPipe(arg3, arg4)
    ) or __TS__ObjectAssign(
        {
            key = ____string(),
            value = arg1
        },
        getErrorAndPipe(arg2, arg3)
    )
    local key = ____temp_0.key
    local value = ____temp_0.value
    local ____error = ____temp_0.error
    local pipe = ____temp_0.pipe
    return {
        schema = "record",
        record = {key = key, value = value},
        async = false,
        _parse = function(self, input, info)
            if not input or type(input) ~= "table" or __TS__ArrayIsArray(input) then
                return {issues = {getIssue(info, {reason = "type", validation = "record", message = ____error or "Invalid type, expected record", input = input})}}
            end
            local issues
            local output = {}
            for ____, inputEntry in ipairs(__TS__ObjectEntries(input)) do
                local inputKey = inputEntry[1]
                if not __TS__ArrayIncludes(BLOCKED_KEYS, inputKey) then
                    local inputValue = inputEntry[2]
                    local path = getPath(info and info.path, {schema = "record", input = input, key = inputKey, value = inputValue})
                    local keyResult = key:_parse(
                        inputKey,
                        getPathInfo(info, path, "key")
                    )
                    if keyResult.issues then
                        if issues then
                            for ____, issue in ipairs(keyResult.issues) do
                                issues[#issues + 1] = issue
                            end
                        else
                            issues = keyResult.issues
                        end
                        if info and info.abortEarly then
                            break
                        end
                    end
                    local valueResult = value:_parse(
                        inputValue,
                        getPathInfo(info, path)
                    )
                    if valueResult.issues then
                        if issues then
                            for ____, issue in ipairs(valueResult.issues) do
                                issues[#issues + 1] = issue
                            end
                        else
                            issues = valueResult.issues
                        end
                        if info and info.abortEarly then
                            break
                        end
                    end
                    if not keyResult.issues and not valueResult.issues then
                        output[keyResult.output] = valueResult.output
                    end
                end
            end
            return issues and ({issues = issues}) or executePipe(
                output,
                pipe,
                getPipeInfo(info, "record")
            )
        end
    }
end
return ____exports
