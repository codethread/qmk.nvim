local ____lualib = require("qmk.lib.lualib_bundle")
local __TS__ArrayIsArray = ____lualib.__TS__ArrayIsArray
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__PromiseAll = ____lualib.__TS__PromiseAll
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.utils.index")
local executePipeAsync = ____index.executePipeAsync
local getErrorAndPipe = ____index.getErrorAndPipe
local getIssue = ____index.getIssue
local getPath = ____index.getPath
local getPathInfo = ____index.getPathInfo
local getPipeInfo = ____index.getPipeInfo
local ____index = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.string.index")
local ____string = ____index.string
local ____values = require("qmk.lib.lua_modules.@codethread.tstl-validate.dist.schemas.record.values")
local BLOCKED_KEYS = ____values.BLOCKED_KEYS
--- Creates an async record schema.
-- 
-- @param value The value schema.
-- @param pipe A validation and transformation pipe.
-- @returns An async record schema.
-- @param value The value schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async record schema.
-- @param key The key schema.
-- @param value The value schema.
-- @param pipe A validation and transformation pipe.
-- @returns An async record schema.
-- @param key The key schema.
-- @param value The value schema.
-- @param error The error message.
-- @param pipe A validation and transformation pipe.
-- @returns An async record schema.
function ____exports.recordAsync(arg1, arg2, arg3, arg4)
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
        async = true,
        _parse = function(self, input, info)
            return __TS__AsyncAwaiter(function(____awaiter_resolve)
                if not input or type(input) ~= "table" or __TS__ArrayIsArray(input) then
                    return ____awaiter_resolve(
                        nil,
                        {issues = {getIssue(info, {reason = "type", validation = "record", message = ____error or "Invalid type, expected record", input = input})}}
                    )
                end
                local issues
                local output = {}
                __TS__Await(__TS__PromiseAll(__TS__ArrayMap(
                    __TS__ObjectEntries(input),
                    function(____, inputEntry)
                        return __TS__AsyncAwaiter(function(____awaiter_resolve)
                            local inputKey = inputEntry[1]
                            if not __TS__ArrayIncludes(BLOCKED_KEYS, inputKey) then
                                local inputValue = inputEntry[2]
                                local path = getPath(info and info.path, {schema = "record", input = input, key = inputKey, value = inputValue})
                                local keyResult, valueResult = unpack(__TS__Await(__TS__PromiseAll(__TS__ArrayMap(
                                    {{schema = key, input = inputKey, origin = "key"}, {schema = value, input = inputValue}},
                                    function(____, ____bindingPattern0)
                                        local origin
                                        local input
                                        local schema
                                        schema = ____bindingPattern0.schema
                                        input = ____bindingPattern0.input
                                        origin = ____bindingPattern0.origin
                                        return __TS__AsyncAwaiter(function(____awaiter_resolve)
                                            if not (info and info.abortEarly and issues) then
                                                local result = __TS__Await(schema:_parse(
                                                    input,
                                                    getPathInfo(info, path, origin)
                                                ))
                                                if not (info and info.abortEarly and issues) then
                                                    if result.issues then
                                                        if issues then
                                                            for ____, issue in ipairs(result.issues) do
                                                                issues[#issues + 1] = issue
                                                            end
                                                        else
                                                            issues = result.issues
                                                        end
                                                        if info and info.abortEarly then
                                                            error(nil, 0)
                                                        end
                                                    else
                                                        return ____awaiter_resolve(nil, result)
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                )):catch(function() return {} end)))
                                if keyResult and valueResult then
                                    output[keyResult.output] = valueResult.output
                                end
                            end
                        end)
                    end
                )))
                return ____awaiter_resolve(
                    nil,
                    issues and ({issues = issues}) or executePipeAsync(
                        output,
                        pipe,
                        getPipeInfo(info, "record")
                    )
                )
            end)
        end
    }
end
return ____exports
